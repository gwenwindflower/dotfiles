#!/usr/bin/env -S deno run --allow-net=api.github.com --allow-env=GITHUB_TOKEN

/**
 * provision-repo.ts
 *
 * Reconciles GitHub Issue labels and Discussions categories for a single
 * Supermodel Labs repo against a manifest. Fixes cosmetic drift in place
 * (colors, descriptions, emojis) and remaps GitHub's default labels and
 * categories onto the manifest where the intent lines up.
 *
 * Behavior:
 * - Labels (REST, fully writable):
 *   - Creates anything missing.
 *   - Updates color/description in place when names match.
 *   - Remaps known GitHub defaults (e.g. 'documentation' → 'type: docs')
 *     when the target slot is empty.
 * - Discussion categories (read-only): GitHub's public GraphQL doesn't
 *   expose category create/update mutations, so we audit only — every
 *   mismatch surfaces as drift for manual fixup in repo Settings →
 *   Discussions.
 * - Never deletes. Anything left over is reported as "extra".
 *
 * Permissions (kept tight):
 *   --allow-net=api.github.com   network only to GitHub's API
 *   --allow-env=GITHUB_TOKEN     read only the token env var
 *
 * Usage:
 *   GITHUB_TOKEN=ghp_... ./provision-repo.ts <repo-name>
 *
 * The org is hardcoded to 'supermodellabs' for this iteration.
 */

const ORG = "supermodellabs";
const API = "https://api.github.com";
const GRAPHQL = "https://api.github.com/graphql";

// ---------------------------------------------------------------------------
// Manifest — single source of truth. Edit here to evolve the org standard.
// ---------------------------------------------------------------------------

type LabelSpec = {
	name: string;
	color: string; // hex without leading #
	description: string;
};

type DiscussionCategorySpec = {
	name: string;
	emoji: string; // single emoji char
	description: string;
	format: "DISCUSSION" | "ANNOUNCEMENT" | "QUESTION_ANSWER";
};

const LABELS: LabelSpec[] = [
	// type
	{
		name: "type: bug",
		color: "ea999c",
		description: "Something isn't working",
	},
	{ name: "type: feature", color: "ca9ee6", description: "New functionality" },
	{
		name: "type: docs",
		color: "8caaee",
		description: "Adding or updating documentation",
	},
	{
		name: "type: chore",
		color: "babbf1",
		description: "Maintenance, tooling, deps",
	},
	{
		name: "type: refactor",
		color: "a6d189",
		description: "Improving code without affecting functionality",
	},

	// status
	{ name: "status: triage", color: "e5c890", description: "Needs triage" },
	{
		name: "status: in-progress",
		color: "1d76db",
		description: "Actively being worked on",
	},
	{
		name: "status: blocked",
		color: "ef9f76",
		description: "Blocked by something else",
	},
	{
		name: "status: needs-info",
		color: "eebebe",
		description: "Awaiting info from reporter",
	},
	{
		name: "status: wontfix",
		color: "f2d5cf",
		description: "This will not be worked on",
	},

	// meta
	{
		name: "good first issue",
		color: "f4b8e4",
		description: "Good for newcomers",
	},
	{
		name: "help wanted",
		color: "85c1dc",
		description: "Extra attention is needed",
	},
	{
		name: "duplicate",
		color: "838ba7",
		description: "This issue or PR already exists",
	},
];

const DISCUSSION_CATEGORIES: DiscussionCategorySpec[] = [
	{
		name: "Announcements",
		emoji: "🤗",
		description: "Updates from Supermodel Labs",
		format: "ANNOUNCEMENT",
	},
	{
		name: "Ideas",
		emoji: "🧐",
		description:
			"Share ideas for new features or improvements — any other general needs beyond Help and Share belong here as well",
		format: "DISCUSSION",
	},
	{
		name: "Help",
		emoji: "🤠",
		description: "Ask questions and get support from the community",
		format: "QUESTION_ANSWER",
	},
	{
		name: "Share",
		emoji: "😍",
		description: "Show off cool stuff you've built with or for this project",
		format: "DISCUSSION",
	},
];

// ---------------------------------------------------------------------------
// Default → manifest remapping. When a key exists on the repo and the value
// (a manifest entry) does NOT exist on the repo, the default is renamed in
// place and its cosmetic fields are overwritten to match the manifest. When
// both exist, we leave the default alone and report it as an extra so the
// human can decide which one to keep.
// ---------------------------------------------------------------------------

const DEFAULT_LABEL_REMAP: Record<string, string> = {
	"bug": "type: bug",
	"documentation": "type: docs",
	"enhancement": "type: feature",
	"wontfix": "status: wontfix",
	// 'invalid' and 'question' don't have clean manifest equivalents — left as
	// extras for manual cleanup.
};

const DEFAULT_CATEGORY_REMAP: Record<string, string> = {
	"Q&A": "Help",
	"Show and tell": "Share",
	"General": "Ideas",
	// 'Polls' has no manifest equivalent — left as an extra.
};

// ---------------------------------------------------------------------------
// Reconciliation report — collected throughout, printed at the end.
// ---------------------------------------------------------------------------

type ReportEntry = {
	area: "labels" | "discussions" | "security";
	level: "created" | "updated" | "remapped" | "drift" | "extra";
	message: string;
};

const report: ReportEntry[] = [];

function record(entry: ReportEntry) {
	report.push(entry);
}

// ---------------------------------------------------------------------------
// HTTP helpers
// ---------------------------------------------------------------------------

function getToken(): string {
	const token = Deno.env.get("GITHUB_TOKEN");
	if (!token) {
		console.error("✗ GITHUB_TOKEN env var is not set.");
		Deno.exit(1);
	}
	return token;
}

async function gh(path: string, init: RequestInit = {}): Promise<Response> {
	const token = getToken();
	const headers = new Headers(init.headers);
	headers.set("Authorization", `Bearer ${token}`);
	headers.set("Accept", "application/vnd.github+json");
	headers.set("X-GitHub-Api-Version", "2022-11-28");
	if (init.body && !headers.has("Content-Type")) {
		headers.set("Content-Type", "application/json");
	}
	return await fetch(`${API}${path}`, { ...init, headers });
}

async function graphql<T>(
	query: string,
	variables: Record<string, unknown>,
): Promise<T> {
	const token = getToken();
	const res = await fetch(GRAPHQL, {
		method: "POST",
		headers: {
			Authorization: `Bearer ${token}`,
			"Content-Type": "application/json",
		},
		body: JSON.stringify({ query, variables }),
	});
	if (!res.ok) {
		throw new Error(`GraphQL HTTP ${res.status}: ${await res.text()}`);
	}
	const json = await res.json();
	if (json.errors) {
		throw new Error(`GraphQL errors: ${JSON.stringify(json.errors)}`);
	}
	return json.data as T;
}

// ---------------------------------------------------------------------------
// Labels
// ---------------------------------------------------------------------------

type RemoteLabel = {
	name: string;
	color: string;
	description: string | null;
};

async function listLabels(repo: string): Promise<RemoteLabel[]> {
	const all: RemoteLabel[] = [];
	let page = 1;
	while (true) {
		const res = await gh(
			`/repos/${ORG}/${repo}/labels?per_page=100&page=${page}`,
		);
		if (!res.ok) {
			throw new Error(
				`Failed to list labels: ${res.status} ${await res.text()}`,
			);
		}
		const batch = (await res.json()) as RemoteLabel[];
		all.push(...batch);
		if (batch.length < 100) break;
		page++;
	}
	return all;
}

async function createLabel(repo: string, spec: LabelSpec): Promise<void> {
	const res = await gh(`/repos/${ORG}/${repo}/labels`, {
		method: "POST",
		body: JSON.stringify({
			name: spec.name,
			color: spec.color,
			description: spec.description,
		}),
	});
	if (!res.ok) {
		throw new Error(
			`Failed to create label '${spec.name}': ${res.status} ${await res.text()}`,
		);
	}
}

/**
 * Update an existing label. When `rename` is true, the label is renamed to
 * spec.name (used for the default-remap pass). When false, only color and
 * description are touched (used for fixing drift on already-named labels).
 */
async function updateLabel(
	repo: string,
	currentName: string,
	spec: LabelSpec,
	rename: boolean,
): Promise<void> {
	const body: Record<string, string> = {
		color: spec.color,
		description: spec.description,
	};
	if (rename) body.new_name = spec.name;
	const res = await gh(
		`/repos/${ORG}/${repo}/labels/${encodeURIComponent(currentName)}`,
		{ method: "PATCH", body: JSON.stringify(body) },
	);
	if (!res.ok) {
		throw new Error(
			`Failed to update label '${currentName}': ${res.status} ${await res.text()}`,
		);
	}
}

async function reconcileLabels(repo: string): Promise<void> {
	console.log("→ Reconciling labels...");
	const manifestByName = new Map(LABELS.map((l) => [l.name, l]));
	const manifestNames = new Set(LABELS.map((l) => l.name));

	let remote = await listLabels(repo);

	// Pass 1: remap GitHub defaults onto empty manifest slots.
	for (const [defaultName, targetName] of Object.entries(DEFAULT_LABEL_REMAP)) {
		const defaultLabel = remote.find((l) => l.name === defaultName);
		if (!defaultLabel) continue;
		const targetExists = remote.some((l) => l.name === targetName);
		if (targetExists) continue; // both present — leave default as an extra
		const spec = manifestByName.get(targetName);
		if (!spec) continue;
		try {
			await updateLabel(repo, defaultName, spec, true);
			record({
				area: "labels",
				level: "remapped",
				message:
					`Renamed default '${defaultName}' → '${targetName}' (color #${spec.color})`,
			});
		} catch (err) {
			record({
				area: "labels",
				level: "drift",
				message:
					`Could not remap '${defaultName}' → '${targetName}': ${
						(err as Error).message
					}`,
			});
		}
	}

	// Re-fetch so subsequent passes see the renames.
	remote = await listLabels(repo);
	const remoteByName = new Map(remote.map((l) => [l.name, l]));

	// Pass 2: create missing, update drifted.
	for (const spec of LABELS) {
		const existing = remoteByName.get(spec.name);
		if (!existing) {
			await createLabel(repo, spec);
			record({
				area: "labels",
				level: "created",
				message: `Created '${spec.name}' (#${spec.color})`,
			});
			continue;
		}
		const drifts: string[] = [];
		if (existing.color.toLowerCase() !== spec.color.toLowerCase()) {
			drifts.push(`color #${existing.color} → #${spec.color}`);
		}
		const remoteDesc = existing.description ?? "";
		if (remoteDesc !== spec.description) {
			drifts.push(`description "${remoteDesc}" → "${spec.description}"`);
		}
		if (drifts.length === 0) continue;
		try {
			await updateLabel(repo, spec.name, spec, false);
			record({
				area: "labels",
				level: "updated",
				message: `Updated '${spec.name}' (${drifts.join("; ")})`,
			});
		} catch (err) {
			record({
				area: "labels",
				level: "drift",
				message: `Could not update '${spec.name}': ${(err as Error).message}`,
			});
		}
	}

	// Pass 3: report extras (anything still on the repo but not in manifest).
	for (const r of remote) {
		if (!manifestNames.has(r.name)) {
			record({
				area: "labels",
				level: "extra",
				message: `'${r.name}' is on the repo but not in the unified labels list`,
			});
		}
	}
}

// ---------------------------------------------------------------------------
// Discussions categories (GraphQL)
// ---------------------------------------------------------------------------

type RemoteCategory = {
	id: string;
	name: string;
	emoji: string;
	description: string;
	// GraphQL exposes `isAnswerable` (Q&A flag) but not a string format.
	// We derive expected answerability from manifest.format === "QUESTION_ANSWER".
	isAnswerable: boolean;
};

type RepoIdAndCategories = {
	repository: {
		id: string;
		discussionCategories: {
			nodes: RemoteCategory[];
		};
	};
};

async function fetchRepoAndCategories(
	repo: string,
): Promise<RepoIdAndCategories> {
	const query = `
    query($owner: String!, $name: String!) {
      repository(owner: $owner, name: $name) {
        id
        discussionCategories(first: 50) {
          nodes {
            id
            name
            emoji
            description
            isAnswerable
          }
        }
      }
    }
  `;
	return await graphql<RepoIdAndCategories>(query, { owner: ORG, name: repo });
}

/**
 * Audit-only: GitHub's public GraphQL API does not expose mutations for
 * creating, updating, or renaming Discussion categories
 * (createDiscussionCategory and updateDiscussionCategory are not defined on
 * the Mutation type). So we report every mismatch — including default
 * categories that *would* be remap candidates — as drift, and leave them
 * for manual fixup in repo Settings → Discussions.
 */
async function reconcileDiscussions(repo: string): Promise<void> {
	console.log("→ Auditing Discussions categories (read-only)...");
	let data: RepoIdAndCategories;
	try {
		data = await fetchRepoAndCategories(repo);
	} catch (err) {
		record({
			area: "discussions",
			level: "drift",
			message:
				`Could not fetch Discussions state — is Discussions enabled on the repo? (${
					(err as Error).message
				})`,
		});
		return;
	}

	const remote = data.repository.discussionCategories.nodes;
	const remoteByName = new Map(remote.map((c) => [c.name, c]));
	const manifestNames = new Set(DISCUSSION_CATEGORIES.map((c) => c.name));

	for (const spec of DISCUSSION_CATEGORIES) {
		const existing = remoteByName.get(spec.name);
		if (!existing) {
			// Hint at a remap target if a known default is sitting in the slot.
			const remapHint = Object.entries(DEFAULT_CATEGORY_REMAP)
				.find(([from, to]) =>
					to === spec.name && remote.some((c) => c.name === from)
				);
			const hintSuffix = remapHint
				? ` — repo has default '${
					remapHint[0]
				}' which you can rename to '${spec.name}' manually`
				: "";
			record({
				area: "discussions",
				level: "drift",
				message:
					`Category '${spec.name}' is missing — create manually in Settings → Discussions (emoji ${spec.emoji}, format ${spec.format})${hintSuffix}`,
			});
			continue;
		}
		const drifts: string[] = [];
		if (existing.emoji && existing.emoji !== spec.emoji) {
			drifts.push(`emoji is ${existing.emoji}, should be ${spec.emoji}`);
		}
		if ((existing.description ?? "") !== spec.description) {
			drifts.push(
				`description is "${existing.description ?? ""}", should be "${spec.description}"`,
			);
		}
		const expectedAnswerable = spec.format === "QUESTION_ANSWER";
		if (existing.isAnswerable !== expectedAnswerable) {
			drifts.push(
				`format is ${
					existing.isAnswerable ? "Q&A" : "non-Q&A"
				}, should be ${spec.format} (fixed at creation time)`,
			);
		}
		if (drifts.length > 0) {
			record({
				area: "discussions",
				level: "drift",
				message:
					`Category '${spec.name}' needs manual edit: ${drifts.join("; ")}`,
			});
		}
	}

	for (const r of remote) {
		if (!manifestNames.has(r.name)) {
			const remapTo = DEFAULT_CATEGORY_REMAP[r.name];
			const hint = remapTo
				? ` — consider renaming to '${remapTo}' manually`
				: "";
			record({
				area: "discussions",
				level: "extra",
				message:
					`Category '${r.name}' is on the repo but not in the unified categories list${hint}`,
			});
		}
	}
}

// ---------------------------------------------------------------------------
// Private vulnerability reporting
// ---------------------------------------------------------------------------

async function reconcilePrivateVulnReporting(repo: string): Promise<void> {
	console.log("→ Reconciling private vulnerability reporting...");
	const get = await gh(
		`/repos/${ORG}/${repo}/private-vulnerability-reporting`,
	);
	if (get.ok) {
		const { enabled } = (await get.json()) as { enabled: boolean };
		if (enabled) return;
	} else if (get.status !== 404) {
		record({
			area: "security",
			level: "drift",
			message: `Could not check PVR state (${get.status}): ${await get.text()}`,
		});
		return;
	}

	const res = await gh(
		`/repos/${ORG}/${repo}/private-vulnerability-reporting`,
		{ method: "PUT" },
	);
	if (res.ok) {
		record({
			area: "security",
			level: "created",
			message: "Enabled private vulnerability reporting",
		});
	} else {
		record({
			area: "security",
			level: "drift",
			message: `Could not enable PVR (${res.status}): ${await res.text()}`,
		});
	}
}

// ---------------------------------------------------------------------------
// Reconciliation report rendering
// ---------------------------------------------------------------------------

function printReport(repo: string): void {
	console.log("");
	console.log("━".repeat(72));
	console.log(`Reconciliation Report — ${ORG}/${repo}`);
	console.log("━".repeat(72));

	const created = report.filter((r) => r.level === "created");
	const updated = report.filter((r) => r.level === "updated");
	const remapped = report.filter((r) => r.level === "remapped");
	const drift = report.filter((r) => r.level === "drift");
	const extra = report.filter((r) => r.level === "extra");

	if (
		created.length === 0 && updated.length === 0 && remapped.length === 0 &&
		drift.length === 0 && extra.length === 0
	) {
		console.log("✓ Repo matches the unified standard. Nothing to address.");
		console.log("━".repeat(72));
		return;
	}

	if (created.length > 0) {
		console.log("");
		console.log(`✓ Created (${created.length}):`);
		for (const e of created) console.log(`  · [${e.area}] ${e.message}`);
	}

	if (remapped.length > 0) {
		console.log("");
		console.log(`↻ Remapped from defaults (${remapped.length}):`);
		for (const e of remapped) console.log(`  · [${e.area}] ${e.message}`);
	}

	if (updated.length > 0) {
		console.log("");
		console.log(`✎ Updated in place (${updated.length}):`);
		for (const e of updated) console.log(`  · [${e.area}] ${e.message}`);
	}

	if (drift.length > 0) {
		console.log("");
		console.log(`! Drift — manual reconciliation needed (${drift.length}):`);
		for (const e of drift) console.log(`  · [${e.area}] ${e.message}`);
	}

	if (extra.length > 0) {
		console.log("");
		console.log(`◇ Extras — on repo but not in manifest (${extra.length}):`);
		for (const e of extra) console.log(`  · [${e.area}] ${e.message}`);
	}

	console.log("");
	console.log("━".repeat(72));
}

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------

async function main(): Promise<void> {
	const repo = Deno.args[0];
	if (!repo) {
		console.error("Usage: provision-repo.ts <repo-name>");
		Deno.exit(2);
	}

	console.log(`Provisioning ${ORG}/${repo}...`);
	console.log("");

	await reconcileLabels(repo);
	await reconcileDiscussions(repo);
	await reconcilePrivateVulnReporting(repo);

	printReport(repo);

	// Exit non-zero if anything still needs human attention.
	const hasDrift = report.some(
		(r) => r.level === "drift" || r.level === "extra",
	);
	Deno.exit(hasDrift ? 1 : 0);
}

if (import.meta.main) {
	await main();
}
