# Reishi config reference

Full annotated `~/.config/reishi/config.toml`:

```toml
sync_method = "copy"            # or "symlink"
default_prefix = "infer"        # or "none"
prefix_separator = "_"
include_shared_agent = true     # ship to ~/.agents/ as the built-in `shared` target
clean_on_sync = false           # batched orphan cleanup at end of `rei sync`

[skills]
source = "~/.config/reishi/skills"

[rules]
source = "~/.config/reishi/rules"

[docs]
source = "~/.config/reishi/docs"
default_target = ".agents/docs"
index_filename = "AGENTS.md"
# token_budget = 4000

[updates]
enabled = true
interval_hours = 24

[agents.claude]
skills = "~/.claude/skills"
rules = "~/.claude/rules"
# compile = true                # ship rules as one concatenated AGENTS.md instead of a dir of files
# compile_root = "~/.claude"    # default: dirname(rules)
# compile_file = "AGENTS.md"

[agents.shared]                 # optional — only needed to override the built-in defaults
# skills = "~/.agents/skills"
# rules = "~/.agents/rules"

[projects.myproj]
path = "~/code/myproj"
# fragments = ["api.md", "testing.md"]   # subset filter

[skill_overrides.book-review]
# sync_method = "symlink"
# agents = ["claude"]            # restrict this skill to a subset of agents
# updates = false                # disable polling for this skill
```
