// Bootstrap a fresh Fly.io Sprite for agent development.
//
// Pulls the dotfiles repo tarball, copies the files listed in manifest.ts
// into place, configures git identity, and switches the login shell to
// fish. Designed to be invoked via `sprite exec` and discarded after
// running — leaves no source tree or extra binaries on disk.
//
// Auth is handled out-of-band: run `gh auth login -p https -w` once on the
// Sprite before bootstrap. gh installs itself as a git credential helper,
// so authenticated HTTPS clone/push/pull works for the lifetime of the
// Sprite without a token in the environment.
//
// Usage:
//   sprite exec -s <name> \
//     'deno run \
//       --allow-net=codeload.github.com,jsr.io \
//       --allow-read \
//       --allow-write=$HOME,$TMPDIR,/tmp \
//       --allow-env=HOME,TMPDIR \
//       --allow-run=git,tar,sudo,chsh,which,id \
//       https://raw.githubusercontent.com/gwenwindflower/dotfiles/main/sprite-bootstrap/main.ts'

import { dirname } from "jsr:@std/path@^1/dirname";
import { dirs, files } from "./manifest.ts";

const REPO = "gwenwindflower/dotfiles";
const BRANCH = "main";
const TARBALL = `https://codeload.github.com/${REPO}/tar.gz/${BRANCH}`;

const HOME = Deno.env.get("HOME");
if (!HOME) {
	console.error("Error: HOME is not set.");
	Deno.exit(1);
}

function expand(p: string): string {
	return p.startsWith("~/") ? `${HOME}/${p.slice(2)}` : p;
}

async function run(
	cmd: string,
	args: string[],
	opts: { stdin?: string } = {},
): Promise<void> {
	const command = new Deno.Command(cmd, {
		args,
		stdin: opts.stdin !== undefined ? "piped" : "inherit",
		stdout: "inherit",
		stderr: "inherit",
	});
	const child = command.spawn();
	if (opts.stdin !== undefined) {
		const w = child.stdin.getWriter();
		await w.write(new TextEncoder().encode(opts.stdin));
		await w.close();
	}
	const { code } = await child.status;
	if (code !== 0) throw new Error(`${cmd} exited ${code}`);
}

console.log("→ configuring git");
await run("git", ["config", "--global", "user.name", "Claude (Sprite)"]);
await run("git", ["config", "--global", "user.email", "noreply@anthropic.com"]);
await run("git", ["config", "--global", "commit.gpgsign", "false"]);
await run("git", ["config", "--global", "init.defaultBranch", "main"]);

const tmp = await Deno.makeTempDir({ prefix: "sprite-bootstrap-" });
console.log(`→ fetching tarball into ${tmp}`);

const res = await fetch(TARBALL);
if (!res.ok || !res.body) {
	throw new Error(`tarball fetch failed: ${res.status} ${res.statusText}`);
}

const tar = new Deno.Command("tar", {
	args: ["-xzf", "-", "--strip-components=1", "-C", tmp],
	stdin: "piped",
	stdout: "inherit",
	stderr: "inherit",
}).spawn();
await res.body.pipeTo(tar.stdin);
{
	const { code } = await tar.status;
	if (code !== 0) throw new Error(`tar exited ${code}`);
}

console.log("→ installing files");
for (const f of files) {
	const absSrc = `${tmp}/${f.src}`;
	const absDest = expand(f.dest);
	await Deno.mkdir(dirname(absDest), { recursive: true });
	await Deno.copyFile(absSrc, absDest);
	if (f.executable) await Deno.chmod(absDest, 0o755);
	console.log(`  ${f.dest}`);
}

for (const d of dirs) {
	const absSrc = `${tmp}/${d.srcDir}`;
	const absDest = expand(d.destDir);
	await Deno.mkdir(absDest, { recursive: true });
	let count = 0;
	for await (const entry of Deno.readDir(absSrc)) {
		if (!entry.isFile) continue;
		await Deno.copyFile(`${absSrc}/${entry.name}`, `${absDest}/${entry.name}`);
		count++;
	}
	console.log(`  ${d.destDir}/ (${count} files)`);
}

console.log("→ switching login shell to fish");
try {
	const which = await new Deno.Command("which", {
		args: ["fish"],
		stdout: "piped",
		stderr: "null",
	}).output();
	const fishPath = new TextDecoder().decode(which.stdout).trim();

	const id = await new Deno.Command("id", {
		args: ["-un"],
		stdout: "piped",
		stderr: "null",
	}).output();
	// Fall back to "sprite" — Fly.io Sprites all use this account name, so
	// the script stays useful even if id/USER both come back empty.
	const username = new TextDecoder().decode(id.stdout).trim() || "sprite";

	if (fishPath && username) {
		await run("sudo", ["-n", "chsh", "-s", fishPath, username]);
	} else {
		console.warn(
			`  (skipping chsh: fish=${fishPath || "missing"} user=${
				username || "missing"
			})`,
		);
	}
} catch (e) {
	console.warn(`  (chsh failed, continuing: ${(e as Error).message})`);
}

console.log("→ cleaning up");
await Deno.remove(tmp, { recursive: true });

console.log("\nSprite bootstrap complete. Clone a repo and run claude.");
