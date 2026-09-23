# Effective skill descriptions

At startup the agent sees only a list of names and descriptions, and the harness truncates that list when it runs long. Each description is a menu entry: it names the domain and what deeper context the skill holds, so the agent can pick it when that context helps. Short entries keep every skill visible.

## Anatomy

```text
<Domain or tool> - <what's inside, as a noun list>. [For <scope>.] [<Adjacent case> uses <other-skill>.]
```

- Aim under 160 characters; 200 is the ceiling. Fragments are fine; caveman style is fine if nothing is lost.
- Lead with the tool or domain name the agent will match against: file types, CLI names, domain terms.
- List contents, not trigger phrases. `Use when the user says X, Y, Z` lists are out.
- Add a routing clause only when an adjacent skill would otherwise be picked wrongly.
- Plain ASCII. No colons, `#`, quotes, backticks, brackets, en or em dashes, or arrows; separate with ` - `, semicolons, or periods so the value stays an unquoted YAML scalar.
- Third person, no "I can" or "You can".

## Examples

| Avoid | Prefer |
| --- | --- |
| `dbt Analytics Engineering` | `dbt projects - models, sources, tests, UDFs, Jinja, CLI builds, deploys, debugging.` |
| `Use when user says "caveman mode", "talk caveman", "go caveman", ...` | `Caveman-style compression of prose to save tokens, live or in files. Toggled on or off by request.` |
| `Generate advanced and comprehensive .gitignore files based on project type...` | `Project-aware .gitignore generation, extension, and audit.` |
| `Use when adding components; customizing variants; troubleshooting setup; ...` | `shadcn/ui components - add, customize variants, components.json, CLI, troubleshooting.` |

## Routing clauses

Examples in this collection:

- `clean-python` routes Pydantic modeling to `pydantic` and dbt Python to `analytics-engineering`
- `zvec-grep` routes exact identifiers to `rg` and markdown to `qmd`
- `writing-prose` excludes agent context, READMEs, and CLI help

If two skills need long routing clauses to stay apart, merge them into one skill with reference docs instead.

## Antipatterns

- Trigger-phrase and scenario lists
- "Always load" or "load for any request"
- Time-stamped guidance ("after April 2026")
- XML tags, which the spec rejects
- Restating the skill name
- YAML quoting to smuggle in special characters
