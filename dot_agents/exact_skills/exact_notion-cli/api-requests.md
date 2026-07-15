# API Requests

Official source: <https://developers.notion.com/cli/guides/api-requests.md>

Use `ntn api` to make Notion API calls without wiring a separate HTTP client. It sets the API headers from the local CLI configuration.

## Request Shape

```bash
ntn api v1/pages/$PAGE_ID
ntn api /v1/pages/$PAGE_ID
```

No body means `GET`. Body input makes `POST` the default unless `-X` overrides it:

```bash
ntn api v1/pages \
  parent[page_id]="$PARENT_PAGE_ID" \
  properties[Name][title][0][text][content]="CLI-created page"

ntn api "v1/pages/$PAGE_ID" -X PATCH archived:=true
```

## Inline Body Syntax

| Syntax | Meaning | Example |
| --- | --- | --- |
| `path=value` | Body field as string | `parent[page_id]=abc123` |
| `path:=json` | Body field parsed as JSON | `archived:=true` |
| `name==value` | Query parameter | `page_size==100` |

Use `:=` for booleans, numbers, `null`, arrays, and objects:

```bash
ntn api "v1/pages/$PAGE_ID" -X PATCH \
  archived:=false \
  properties[Priority][number]:=2
```

Use raw JSON when nested inline input becomes hard to read:

```bash
ntn api v1/search \
  filter:='{"property":"object","value":"page"}' \
  page_size:=10
```

Dot and bracket paths are both valid. Bracket paths handle property names with spaces:

```bash
ntn api "v1/pages/$PAGE_ID" -X PATCH \
  properties[Build version][rich_text][0][text][content]="2026.05.11"
```

Repeated empty brackets append array items:

```bash
ntn api v1/comments \
  parent[page_id]="$PAGE_ID" \
  rich_text[][text][content]="First comment line" \
  rich_text[][text][content]="Second comment line"
```

## Body Sources

Use exactly one body source: inline fields, stdin JSON, or `--data`.

```bash
ntn api v1/pages < create-page.json
printf '%s\n' '{"query":"roadmap","page_size":10}' | ntn api v1/search
ntn api v1/search --data '{"query":"roadmap","page_size":10}'
```

## Queries, Headers, and Versions

Use `==` for query parameters:

```bash
ntn api v1/search query==roadmap page_size==10
```

Only add headers when needed. The CLI already sets auth and Notion version:

```bash
ntn api v1/users -H "Accept-Language: en-US"
```

Pin an API version only when required:

```bash
ntn api v1/users/me --notion-version 2026-03-11
NOTION_API_VERSION=2026-03-11 ntn api v1/users/me
```

## Discovery and Debugging

```bash
ntn api ls
ntn api ls --json
ntn api v1/comments --help
ntn api v1/comments --spec -X POST
ntn api v1/comments --docs -X POST
```

If a path supports multiple methods, pass `-X` when asking for `--spec` or `--docs`.

Troubleshooting defaults:

- Unexpected `POST`: body input, stdin JSON, or `--data` was present; pass `-X GET` or remove the body.
- Wrong JSON type: use `:=` instead of `=`.
- Body source conflict: keep only one of inline fields, stdin, or `--data`.
- Opaque error: rerun with `--verbose`.
