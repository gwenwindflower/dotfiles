# Maintaining Linear Agent skills

Linear Agent skills are Markdown instructions stored inside Linear, distinct from locally installed agent skills and always-loaded personal guidance. The connector exposes `list_agent_skills` and `get_agent_skill`; use `linear-cli api` for writes. [API documentation](https://linear.app/developers/graphql) and [official schema](https://github.com/linear/linear/blob/master/packages/sdk/src/schema.graphql).

## Workflow

1. Confirm the workspace and intended owner or team. List existing skills before creating; fetch the full body and metadata before updating. Keep that response as the recovery copy.
2. Draft Markdown in a temp file, using the fetched body for an update. Make it self-contained for an agent operating in Linear: no local paths, skill dependencies, or assumed repo access. Distill only the relevant guidance; adapt structure to the task.
3. A request to create or maintain the skill authorizes the write. A draft request stops at review. Preserve unrelated edits and re-read before writing if the draft has been under review; reconcile intervening changes.
4. Create a separate skill only when intended; otherwise update its ID. Supply `teamId` for team scope. Inspect `errors` and mutation `success`, then fetch again to verify body, title, and team. Linear may normalize Markdown list markers and whitespace.
5. If a create request times out, list skills before retrying to avoid duplicates. Report the resulting skill and scope; don't retire another skill unless asked.

## API examples

These Bash/zsh examples use the Lightdash profile; substitute the intended workspace elsewhere. Read `linear-cli api query --help` and `linear-cli api mutate --help` for the installed version. Pass Markdown as a variable, or generate a GraphQL file with a serializer and submit it through stdin; never interpolate unescaped Markdown into GraphQL source.

```sh
linear-cli --profile lightdash api query -o json \
  'query { agentSkills(first: 100) {
    nodes { id title teamId }
    pageInfo { hasNextPage endCursor }
  } }'

linear-cli --profile lightdash api query -o json \
  'query($id: String!) { agentSkill(id: $id) { id title body teamId } }' \
  -v id=SKILL_UUID

linear-cli --profile lightdash api mutate -o json \
  'mutation($id: String!, $body: String!) {
    agentSkillUpdate(id: $id, input: { body: $body }) {
      success agentSkill { id title body teamId }
    }
  }' -v id=SKILL_UUID -v body="$(< /path/to/draft.md)"

linear-cli --profile lightdash api mutate -o json \
  'mutation($title: String!, $body: String!, $team: String!) {
    agentSkillCreate(input: { title: $title, body: $body, teamId: $team }) {
      success agentSkill { id title body teamId }
    }
  }' -v title="Skill title" -v body="$(< /path/to/draft.md)" -v team=TEAM_UUID
```

Follow `pageInfo` with `after: endCursor` when more pages remain. `agentSkillUpdate` also accepts `title`, `teamId`, `icon`, and `color`; omit fields that aren't changing. Inspect the live schema before relying on other fields or changing sharing behavior.

## Lightdash AE example

| Field | Value |
| --- | --- |
| Title | Create AE-quality issues |
| Skill ID | `1cccb324-e530-4899-bf51-4d3299dafa16` |
| Team | Analytics Engineering (`AE`) |
| Team ID | `0a8e6a66-c4bb-4b56-9f7e-6f9dda3d530a` |

If you need an example, fetch this skill to see what the API calls return and how the Markdown is structured. It contains guidance for the Linear Agent to write issues that meet the Lightdash AE team's quality standards.
