# Global agent guidance

## Foundations

{{ joinPath .chezmoi.sourceDir ".chezmoitemplates/agents/rules/primary-user.md.age" | include | decrypt }}
{{ template "agents/rules/communication.md" . }}
## Work

{{ template "agents/rules/workflow.md" . }}
{{ template "agents/rules/exploration.md" . }}
{{ template "agents/rules/tools.md" . }}
{{ template "agents/rules/git.md" . }}
{{ template "agents/rules/config.md" . }}
## Output

{{ template "agents/rules/output.md" . }}
