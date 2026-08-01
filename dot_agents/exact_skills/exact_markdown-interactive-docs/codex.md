# Delivery: Sites (Codex)

Sites is the hosted Codex equivalent for durable web output: a persistent project with saved versions, production deployments, audience controls, and a shareable URL. Unlike a Claude Artifact, Sites deploys a compatible project rather than accepting the built HTML as a standalone artifact.

## Flow

1. Load `sites-building`, then `sites-hosting`; their current project and connector contracts take precedence over this reference.
2. Keep the Markdown source, `template.html`, and `build.ts` as the content pipeline. Build and inspect the generated HTML before preparing the Site.
3. Ask Sites to adapt the project for its supported runtime. Do not call hosting tools directly on `dist/<stem>.html` or replace the editable source pipeline with generated output.
4. Let `sites-hosting` create or reuse the Site, save a version from the validated source commit, deploy it privately, wait for completion, and return the production URL.
5. Use Sites in ChatGPT web or the desktop app to inspect saved versions, deploy a selected version, or change access.

## Rules

- Every deployment URL is production. Save a version without deploying when review is required first.
- Keep a Site owner-only while reviewing it. Expand access only to the audience the user requests; sharing can support selected people or groups, the workspace, or the public when account policy allows it.
- Do not add D1, R2, authentication, or other application infrastructure for a static interactive document.
- Preserve `.openai/hosting.json` as Sites project metadata and keep secrets in hosted environment settings, never in the manifest or source.
- Codex CLI and the IDE extension can edit and test the local project but do not provide the Sites management view; use ChatGPT web or the desktop app for project, version, deployment, and sharing management.

Current product behavior: [Sites documentation](https://learn.chatgpt.com/docs/sites).
