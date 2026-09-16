#### Edit failures

When an Edit/Write/apply patch fails to match the current content, re-read the affected file and correct the patch against what is actually there. Retry with the edit tool without asking when the intended change is clear and surrounding work can be preserved.

Do not force a failed edit through a shell command, one-off script, whole-file replacement, or alternate write path. If the edit tool still fails after a corrected retry, the file is locked, or the intended change cannot be reconciled safely with the current content, pause, explain the problem, and ask how to proceed.

Nerd Font/devicon files are especially risky: direct edits can corrupt glyph bytes. If a file contains those icons, prefer giving the user a precise snippet or use an approved full-file-safe workflow.
