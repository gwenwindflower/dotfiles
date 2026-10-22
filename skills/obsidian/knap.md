# knap

knap renders Markdown from a template and JSON or CSV data: `{{ variable }}` for values, `|` for filters, `{% ... %}` for logic. It is the template language behind Obsidian's Web Clipper and Importer. Use it to turn structured data into notes, one at a time or in batches.

The CLI carries its own offline language reference. Look up names in the lists, then ask for the one you need:

```bash
knap help syntax
knap help filters        # list; `knap help filter date` for one
knap help tags           # list; `knap help tag for` for one
```

## Render one note

```bash
knap render template.md --data article.json -o note.md
knap render -t '# {{ title | trim }}' --data-json '{"title":"Hello"}'
cat article.json | knap render template.md --data - --set 'title=Custom title'
```

- Data is one JSON object; its top-level keys become variables. `--set` overrides a top-level key with a string, so pass nested values, arrays, numbers, and booleans as JSON.
- Pick one template source (file, `-t`, or stdin) and one data source (`--data` or `--data-json`); only one of them can read stdin.
- Output goes to stdout by default. `-o` creates parent directories and overwrites the destination once rendering succeeds, so point it at a fresh path inside the vault or render to stdout and write with [notesmd-cli](notesmd-cli.md).
- Errors exit 1 with diagnostics on stderr; warnings can accompany successful output.

## Templates

```knap
---
{{ title | yaml_property:"title" }}
{{ tags | yaml_property:"tags" }}
---
# {{ title | trim }}
{% if author %}
By {{ author }}
{% endif %}

{{ content }}
```

- Write each frontmatter property with `yaml_property` so values are quoted and indented correctly. Property names and shapes follow the vault's patterns ([markdown](markdown.md#properties)).
- The CLI has no Web Clipper browser variables, selectors, prompts, or DOM-dependent HTML filters; every variable comes from the data.
- Keep authoring notes that should never ship in `{# ... #}` comments; they are dropped from the output unevaluated and may span lines.
- `knap validate template.md` checks syntax, filter names, and static filter arguments. It cannot see variable existence or runtime values, so render with real data before a batch.

## Batch rendering

One file per CSV row, JSON array item, or JSON file in a folder:

```bash
knap batch template.md --data articles.csv --output-dir notes \
  --filename '{{ title | safe_name }}.md' --dry-run
```

- `--data` takes a `.csv`, a `.json` array, or a folder of JSON objects. CSV headers become variables and every value stays a string. Piped data is JSON unless `--format csv`.
- A filename template yields one filename with its extension and no directories; wrap data-derived names in `safe_name`. Without `--filename`, JSON files keep their basenames and rows or array items number from `1.md`.
- Existing files need `--overwrite`, even on a dry run, and duplicate names in one batch always fail.
- A batch into the vault is a change set: show the `--dry-run` path list and get a yes before writing.
