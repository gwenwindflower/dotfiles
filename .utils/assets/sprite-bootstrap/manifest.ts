// Affirmative allowlist of files, dirs, and symlinks materialized from the
// dotfiles tarball into a fresh Sprite. The bootstrap walks `dirs`
// recursively and strips chezmoi attribute prefixes (`exact_`,
// `executable_`, `dot_`, `private_`) from each path segment, so source
// paths here use the on-disk source-state names exactly as they appear in
// the repo.
//
// `~` in dest paths expands to $HOME.

export type FileEntry = {
	src: string;
	dest: string;
	executable?: boolean;
};

export type DirEntry = {
	srcDir: string;
	destDir: string;
};

export type SymlinkEntry = {
	target: string;
	link: string;
};

export const files: FileEntry[] = [
	{ src: "dot_claude/CLAUDE.md", dest: "~/.claude/CLAUDE.md" },
	{
		src: ".utils/assets/sprite-bootstrap/settings.json",
		dest: "~/.claude/settings.json",
	},
	{
		src: ".utils/assets/sprite-bootstrap/fish/abbreviations.fish",
		dest: "~/.config/fish/conf.d/abbreviations.fish",
	},
	{
		src: "private_dot_config/herdr/config.toml",
		dest: "~/.config/herdr/config.toml",
	},
];

export const dirs: DirEntry[] = [
	{ srcDir: "dot_claude/exact_hooks", destDir: "~/.claude/hooks" },
	{ srcDir: "dot_agents/exact_rules", destDir: "~/.agents/rules" },
	{ srcDir: "dot_agents/exact_skills", destDir: "~/.agents/skills" },
	{
		srcDir: "private_dot_config/opencode/exact_agents",
		destDir: "~/.config/opencode/agents",
	},
	{
		srcDir: "private_dot_config/opencode/plugins",
		destDir: "~/.config/opencode/plugins",
	},
];

// Mirror chezmoi's `~/.claude/{rules,skills}` -> `~/.agents/{rules,skills}`
// symlinks so Claude Code picks up the shared agent collections.
export const symlinks: SymlinkEntry[] = [
	{ target: "~/.agents/rules", link: "~/.claude/rules" },
	{ target: "~/.agents/skills", link: "~/.claude/skills" },
];
