#### Edit Failures

When an Edit/Write/apply patch fails because content is missing, ambiguous, locked, or unexpectedly different, stop. Re-read the file, explain the mismatch, and ask the user how to proceed.

Do not bypass the failure by overwriting the file with shell commands, replacing the whole file, or using a different write path. A failed edit is evidence that your mental model is stale.

Nerd Font/devicon files are especially risky: direct edits can corrupt glyph bytes. If a file contains those icons, prefer giving the user a precise snippet or use an approved full-file-safe workflow.
