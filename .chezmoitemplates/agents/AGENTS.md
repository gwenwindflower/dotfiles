# Global agent guidance

## Foundations

{{ joinPath .chezmoi.sourceDir ".chezmoitemplates/agents/rules/primary-user.md.age" | include | decrypt }}

{{ template "agents/rules/communication.md" . }}

{{ template "agents/rules/interpretation.md" . }}

{{ template "agents/rules/naming.md" . }}

{{ template "agents/rules/current-state.md" . }}

{{ template "agents/rules/task-restraint.md" . }}

## Workflow

{{ template "agents/rules/use-tdd.md" . }}

{{ template "agents/rules/projects.md" . }}

{{ template "agents/rules/exploration.md" . }}

{{ template "agents/rules/tools.md" . }}

{{ template "agents/rules/fish-variables.md" . }}

### Failures

{{ template "agents/rules/sandbox-failures.md" . }}

{{ template "agents/rules/edit-failures.md" . }}

### Git

{{ template "agents/rules/git-commits.md" . }}

{{ template "agents/rules/github.md" . }}

## Output

{{ template "agents/rules/markdown-editing.md" . }}

{{ template "agents/rules/code-comments.md" . }}
