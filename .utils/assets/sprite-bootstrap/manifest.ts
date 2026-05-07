// Affirmative allowlist of files, dirs, and post-install copies materialized
// from the dotfiles tarball into a fresh Sprite. The bootstrap walks `dirs`
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
	// Source-state paths within srcDir (relative, with chezmoi prefixes
	// intact) to skip during the recursive copy.
	exclude?: string[];
};

// Post-install on-disk copy. Source is a path that the file/dir steps
// already populated. Used to mirror shared agent config into Claude's
// dirs without clobbering Sprite-managed defaults (which a symlink would).
export type CopyEntry = {
	src: string;
	dest: string;
};

export const files: FileEntry[] = [
	{ src: "dot_claude/CLAUDE.md", dest: "~/.claude/CLAUDE.md" },
	{ src: "dot_claude/keybindings.json", dest: "~/.claude/keybindings.json" },
	{
		src: "dot_claude/dot_markdownlint.yaml",
		dest: "~/.claude/.markdownlint.yaml",
	},
	// Doc fragments referenced by CLAUDE.md.
	{ src: "dot_claude/private_gitsigning.md", dest: "~/.claude/gitsigning.md" },
	{
		src: "dot_claude/private_supermodellabs.md",
		dest: "~/.claude/supermodellabs.md",
	},
	{ src: "dot_claude/private_tmpdirs.md", dest: "~/.claude/tmpdirs.md" },
	{
		src: ".utils/assets/sprite-bootstrap/settings.json",
		dest: "~/.claude/settings.json",
	},
	{
		src: ".utils/assets/sprite-bootstrap/fish/abbreviations.fish",
		dest: "~/.config/fish/conf.d/abbreviations.fish",
	},
];

export const dirs: DirEntry[] = [
	{
		srcDir: "dot_claude/exact_hooks",
		destDir: "~/.claude/hooks",
		// herdr daemon doesn't run on Sprite OS.
		exclude: ["executable_herdr-agent-state.sh"],
	},
	{ srcDir: "dot_agents/exact_rules", destDir: "~/.agents/rules" },
	{ srcDir: "dot_agents/exact_skills", destDir: "~/.agents/skills" },
	{
		srcDir: "private_dot_config/opencode",
		destDir: "~/.config/opencode",
		exclude: ["plugins/herdr-agent-state.js"],
	},
	{ srcDir: "private_dot_config/tmux", destDir: "~/.config/tmux" },
];

// Mirror shared agent config into ~/.claude/{rules,skills}. Copy rather
// than symlink so we additively merge with Sprite-preinstalled skills
// instead of clobbering them.
export const copies: CopyEntry[] = [
	{ src: "~/.agents/rules", dest: "~/.claude/rules" },
	{ src: "~/.agents/skills", dest: "~/.claude/skills" },
];
