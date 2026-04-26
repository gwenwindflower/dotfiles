# Effective Skill Descriptions

The description is the only metadata Claude sees at startup. It must answer two questions in 1–3 sentences: **what** and **when**.

## Anatomy

```text
<verb-phrase: what it does>. Use when <concrete triggers>. [Skip when <adjacent-but-wrong cases>.]
```

Constraints:

- ≤1024 chars hard limit; aim well under
- Third person only — never "I can…" or "You can…"
- Concrete keywords users actually say: file extensions, CLI names, domain terms
- Slightly directive — Claude under-triggers by default

## Bad → good

**Vague**

- ❌ `dbt Analytics Engineering`
- ✅ `Build, test, and debug dbt projects: models, tests, semantic layer, CLI. Use when editing files in a dbt project (.sql/.yml under models/, dbt_project.yml) or running dbt commands.`

**First-person, no triggers**

- ❌ `Always load when working with fish files to get guidance on idiomatic fish syntax and better terminal UX.`
- ✅ `Idiomatic fish shell scripting: functions, completions, abbreviations, conf.d. Use when editing .fish files or fish config under ~/.config/fish.`

**Step list bloat**

- ❌ `Use when: (1) Adding shadcn components, (2) Customizing components with variants, (3) Understanding the architecture, (4) Troubleshooting setup.`
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

- Numbered "Use when: (1)… (2)…" lists — wasteful, doesn't improve triggering
- "Always load" / "load for any request" — too aggressive, mistriggers
- Time-stamped guidance ("after April 2026…")
- XML tags inside the description — rejected by spec
- Restating the skill name in the description body
- Listing every feature instead of the actual triggers users will type
- YAML quoting (`"…"`) unless the value contains a colon or starts with a special char

## Self-check

Before shipping, write 5 prompts that should trigger and 5 that should not. If your description doesn't clearly cover both, tighten it.
