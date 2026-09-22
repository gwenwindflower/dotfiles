# Content Commands

Official sources:

- <https://developers.notion.com/cli/guides/data-sources.md>
- <https://developers.notion.com/cli/guides/file-uploads.md>
- <https://developers.notion.com/cli/reference/commands.md>

## Pages

Use page commands for Markdown-oriented workflows:

```bash
ntn pages get <page-id>
ntn pages get <page-id> --json
ntn pages create --parent page:<id> --content "# Title"
ntn pages create --parent database:<id> < page.md
ntn pages create --parent data-source:<id> < page.md
ntn pages edit <page-id> --content "Updated content"
ntn pages trash <page-id>
```

`pages edit` may delete child pages or databases only when `--allow-deleting-content` is passed. Preserve confirmations around `pages trash` unless the user explicitly asks for `--yes`.

## Data Sources

Use `ntn datasources` for common query and resolve tasks:

```bash
ntn datasources resolve <database-id>
ntn datasources query <data-source-id> --limit 50
ntn datasources query <data-source-id> --filter '{"property":"Status","select":{"equals":"Open"}}'
ntn datasources query <data-source-id> --filter-file filter.json
```

Use `--start-cursor` with a previous `next_cursor` for pagination. Add `--json` for parsing.

Drop to `ntn api` for sorts, `filter_properties`, schema edits, templates, or endpoint discovery:

```bash
ntn api v1/data_sources/<data-source-id>/query \
  filter:='{"and":[{"property":"Status","select":{"equals":"Open"}},{"property":"Priority","number":{"greater_than_or_equal_to":2}}]}' \
  sorts:='[{"property":"Priority","direction":"descending"}]' \
  page_size:=25

ntn api 'v1/data_sources/<data-source-id>/query?filter_properties[]=title&filter_properties[]=Status'
ntn api v1/data_sources --spec -X POST
ntn api v1/data_sources --docs -X POST
```

When creating a data source, `parent[type]=database_id` is the discriminator and `parent[database_id]` is the database ID:

```bash
ntn api v1/data_sources \
  parent[type]=database_id \
  parent[database_id]=<database-id> \
  title[0][type]=text \
  title[0][text][content]="Bugs" \
  properties:='{"Name":{"title":{}},"Status":{"select":{"options":[{"name":"Open","color":"red"},{"name":"Closed","color":"green"}]}}}'
```

## File Uploads

`ntn files create` reads bytes from stdin, creates the File Upload object, uploads bytes, completes the upload, and prints the upload ID.

```bash
ntn files create < ./photo.png
ntn files create --json < ./photo.png
FILE_UPLOAD_ID=$(ntn files create --plain < ./photo.png | cut -f1)
```

Override filename or content type when stdin loses metadata:

```bash
generate-pdf | ntn files create --filename report.pdf --content-type application/pdf
```

Import external URLs:

```bash
FILE_UPLOAD_ID=$(ntn files create --plain --external-url https://example.com/photo.png | cut -f1)
ntn files get "$FILE_UPLOAD_ID"
```

Uploads are not attached automatically. Attach the upload with `ntn api`:

```bash
FILE_UPLOAD_ID=$(ntn files create --plain < ./photo.png | cut -f1)

ntn api "v1/blocks/$PAGE_ID/children" -X PATCH \
  children[0][type]=image \
  children[0][image][type]=file_upload \
  children[0][image][file_upload][id]="$FILE_UPLOAD_ID"
```

Use `ntn files list` and `ntn files get <upload-id>` to inspect uploads. `ntn files list` returns only the first page; use `ntn api v1/file_uploads start_cursor=="$NEXT_CURSOR"` for cursor pagination.
