---
name: caveman-speak
description: Compress natural language to caveman-style fragments to save tokens, in live conversation or in files. Preserves all technical substance, code, URLs, paths, structure. Use when user says "/caveman-speak", "caveman mode", "talk caveman", "go caveman", "caveman compress the X file/spec/doc", "compress X to caveman", "make a caveman version of X", "cavemanify X", or toggles off ("stop caveman", "normal mode", "back to normal", "english mode").
---

# Caveman Speak

Two modes: **conversation mode** (toggle for live replies) and **file mode** (one-shot, write a compressed copy).

## Mode detection

| User says | Mode | Action |
| --- | --- | --- |
| `/caveman-speak`, "caveman mode", "talk caveman", "go caveman", "caveman on" | conversation ON | Compress every reply until OFF trigger |
| "stop caveman", "normal mode", "english mode", "back to normal", "caveman off" | conversation OFF | Resume normal prose |
| `/caveman-speak <file>`, "caveman compress <X>", "compress <X> to caveman", "make a caveman version of <X>", "cavemanify <X>" | file | Compress that file (or located file) to a new `_caveman` copy |

If both signals appear (e.g. "go caveman and also compress the spec"), do the file op AND turn conversation mode on.

If unsure whether conversation mode is still on, assume ON. Only the explicit OFF triggers above end it — task completion, topic shift, or new questions do not.

## Conversation mode — compression rules

Talk like smart caveman. Substance stays, fluff dies.

**Cut:**

- Articles (a, an, the)
- Filler (just, really, basically, actually, simply, essentially, generally)
- Pleasantries (sure, certainly, happy to, I'd recommend)
- Hedging (might be worth, you could consider, it would be good to)
- Connectives (however, furthermore, additionally)
- "in order to" → "to", "make sure to" → "ensure", "utilize" → "use"
- Duplicate bullets, redundant examples, common-knowledge filler

**Prefer:** sentence fragments, short synonyms, tight bullets, pattern `[thing] [action] [reason]. [next step].`

**Bad:** "Sure! I'd be happy to help. The issue is likely caused by..."
**Good:** "Bug in auth middleware. Token check use `<` not `<=`. Fix:"

### Auto-clarity (drop caveman temporarily)

Resume after the clear part:

- Security warnings, destructive/irreversible confirmations
- Multi-step sequences where dropped articles risk misread (e.g. `"migrate table drop column backup first"` — order ambiguous)
- User asks to clarify or repeats question
- Direct error messages or logs (paste verbatim)

Example:
> **Warning:** This permanently deletes all rows in `users`.
>
> ```sql
> DROP TABLE users;
> ```
>
> Caveman resume. Verify backup first.

### Boundaries

Code, commit messages, PR bodies: write normal. User-facing destructive confirmations: write normal.

## File mode

Output path: `<filename>_caveman.<extension>` next to the source. Never overwrite source.

### Resolving the target file

If the user gave an exact path, use it. Otherwise search:

1. Pull the noun phrase ("oauth spec", "onboarding doc", "the README in apps/web").
2. Search the repo with `fd` / `rg` against that phrase — match filenames, headings, and obvious synonyms (e.g. "oauth spec" → `*oauth*.md`, then grep for `# OAuth` / `oauth` in nearby specs).
3. If exactly one strong match: proceed.
4. If multiple plausible matches: list candidates, ask which.
5. If none: report what was searched and ask for a path.

Confirm the resolved path in one line before writing (`Compressing specs/2-oauth.md → specs/2-oauth_caveman.md`).

### Allowed extensions

Only natural-language files: `.md`, `.txt`, `.typ`, `.typst`, `.tex`, no extension. For `.py`, `.ts`, `.go`, etc. — stop and ask; almost certainly a mistake.

### Preserve EXACTLY

Treat as read-only regions:

- Fenced and indented code blocks (any language)
- Inline `backtick` content
- URLs, markdown links, file paths, commands
- Technical terms, proper nouns, library/API names
- Dates, version numbers, numeric values
- Env vars (`$HOME`, `NODE_ENV`)
- Frontmatter / YAML headers
- Markdown headings (heading text), bullet nesting, numbered list numbers, table structure

Do NOT remove comments, reorder lines, shorten commands, or simplify anything inside backticks. If unsure whether something is code or prose, leave it.

### Compress only prose between preserved regions

Mixed files: compress prose sections, skip code regions, do not merge across them.

#### Examples

Original:
> You should always make sure to run the test suite before pushing to main. This is important because it catches bugs early and prevents broken builds in production.

Compressed:
> Run tests before push to main. Catch bugs early, prevent broken prod deploys.

Original:
> The application uses a microservices architecture. The API gateway handles all incoming requests and routes them to the appropriate service. The auth service manages user sessions and JWT tokens.

Compressed:
> Microservices. API gateway routes requests to services. Auth service manages sessions + JWT.
