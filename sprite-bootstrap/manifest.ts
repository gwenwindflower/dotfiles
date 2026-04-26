// Affirmative allowlist of files copied from the dotfiles tarball into a
// fresh Sprite. Add an entry here to make a file Sprite-bound. The src path
// is the path inside the repo tarball; dest is the on-Sprite destination
// (~ expands to $HOME).

export type FileEntry = {
	src: string;
	dest: string;
	executable?: boolean;
};

export type DirEntry = {
	srcDir: string;
	destDir: string;
};

export const files: FileEntry[] = [
	{ src: "dot_claude/CLAUDE.md", dest: "~/.claude/CLAUDE.md" },
	{ src: "sprite-bootstrap/settings.json", dest: "~/.claude/settings.json" },
	{
		src: "dot_claude/hooks/executable_inject-commit-reminder.sh",
		dest: "~/.claude/hooks/inject-commit-reminder.sh",
		executable: true,
	},
	{
		src: "dot_claude/hooks/executable_require-teammate-commit.sh",
		dest: "~/.claude/hooks/require-teammate-commit.sh",
		executable: true,
	},
	{
		src: "dot_claude/hooks/executable_set-sandbox-tmpdir.sh",
		dest: "~/.claude/hooks/set-sandbox-tmpdir.sh",
		executable: true,
	},
	{
		src: "sprite-bootstrap/fish/abbreviations.fish",
		dest: "~/.config/fish/conf.d/abbreviations.fish",
	},
];

export const dirs: DirEntry[] = [
	{ srcDir: "dot_agents/rules", destDir: "~/.claude/rules" },
];
