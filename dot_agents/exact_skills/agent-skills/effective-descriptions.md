# Effective Skill Descriptions

The description is the only metadata Claude sees at startup. It must answer two questions in 1–3 sentences: **what** and **when**.

## Anatomy

```text
<verb phrase for what it does>. Use when <concrete triggers>. [Skip when <adjacent-but-wrong cases>.]
```

Constraints:

- <1000 chars — hard limit for this collection (platform allows 1024, but we stay under 1000); aim well under
- Third person only — never "I can…" or "You can…"
- Concrete keywords users actually say: file extensions, CLI names, domain terms
- Slightly directive — Claude under-triggers by default
- Never use colons in YAML frontmatter descriptions. Use semicolons, em dashes, or a second sentence instead so the value stays a plain scalar.
- Avoid long scenario lists. They bloat startup context and usually trigger worse than one clear sentence with concrete keywords.

## Bad → good

**Vague**

- ❌ `dbt Analytics Engineering`
- ✅ `Build, test, and debug dbt projects — models, tests, semantic layer, CLI. Use when editing files in a dbt project (.sql/.yml under models/, dbt_project.yml) or running dbt commands.`

**First-person, no triggers**

- ❌ `Always load when working with fish files to get guidance on idiomatic fish syntax and better terminal UX.`
- ✅ `Idiomatic fish shell scripting — functions, completions, abbreviations, conf.d. Use when editing .fish files or fish config under ~/.config/fish.`

**Long scenario list**

- ❌ `Use when adding shadcn components; customizing variants; understanding architecture; troubleshooting setup; auditing style; checking installation; updating themes.`
- ✅ `Add, customize, and troubleshoot shadcn/ui components. Use when working with shadcn components, variants, or components.json.`

**Restating without triggers**

- ❌ `Generate advanced and comprehensive .gitignore files based on project type, using stringent syntax for selecting and excluding files and directories.`
- ✅ `Generate or extend .gitignore files with project-aware patterns. Use when creating .gitignore, adding ignores for a new tool/language, or auditing an existing one.`

## Skip-when guards

Add `Skip when …` only for adjacent skills that would otherwise mistrigger. Examples in this collection:

- `claude-api` skips OpenAI/provider-neutral SDKs
- `writing-prose` skips agent context files (handled by `agent-context-engineering`)
- `obsidian-cli` skips static markdown editing (handled by `obsidian-markdown`)

If two skills have overlapping triggers and no clean disambiguator, that's a signal to merge them, not to write longer descriptions.

## Antipatterns

- Numbered scenario lists — wasteful, doesn't improve triggering
- Colon-separated scenario lists — colons break YAML parsing too easily; write a sentence such as `Use when drafting bugs, specs, or tickets` or split conditions with semicolons.
- "Always load" / "load for any request" — too aggressive, mistriggers
- Time-stamped guidance ("after April 2026…")
- XML tags inside the description — rejected by spec
- Restating the skill name in the description body
- Listing every feature instead of the actual triggers users will type
- Colons in YAML frontmatter descriptions — they break too easily during edits
- YAML quoting (`"…"`) for descriptions — prefer wording that remains a plain scalar
