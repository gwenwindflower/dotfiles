# herdir

`herdir` keeps named herdr sessions seeded with a base set of workspaces, tabs,
and panes. It is additive-only: existing matching layout is left alone, and
extra workspaces, tabs, or panes are ignored.

Run from the fish wrapper or from `.utils`:

```text
herdir --dry-run
herdir snapshot lightdash

deno task herdir -- --dry-run
deno task herdir
deno task herdir -- --manifest ./other.yaml
```

Default manifest: `.utils/herdir.yaml`. Snapshots are written to
`.utils/assets/herdir-snapshots/<session>.yaml`; YAML files in that directory
are ignored so temporary captures do not add git noise.

## Manifest

```yaml
sessions:
  - name: dotfiles
    workspaces:
      - name: optional-workspace-label
        path: ~/.local/share/chezmoi
        tabs:
          - name: codex
            path: ~/.local/share/chezmoi
            panes:
              - path: ~/.local/share/chezmoi
                split: right
                ratio: 0.5
```

Fields:

- `sessions[].name`: herdr session name.
- `workspaces[].path`: workspace identity path.
- `workspaces[].name`: optional workspace label.
- `tabs[].name`: optional tab label.
- `tabs[].path`: root tab path, defaults to the workspace path.
- `tabs[].panes`: additional base panes to ensure inside the tab.
- `panes[].path`: pane cwd, defaults to the tab path.
- `panes[].split`: `right` or `down`, default `right`.
- `panes[].ratio`: optional herdr split ratio.

The root pane created by `workspace create` or `tab create` counts as a pane for
matching. `panes` only creates missing panes; it does not close or move extras.

## Snapshot Workflow

1. Arrange a herdr session manually.
2. Run `herdir snapshot <session>`.
3. Copy the session, workspace, tab, or pane branches you want from the
   generated snapshot into `herdir.yaml`.
4. Edit the manifest down to the base layout you want `herdir` to recreate.
5. Run `herdir --dry-run`, then `herdir`.

Snapshots are distilled from `~/.config/herdr/sessions/<session>/session.json`.
Tab root panes become `tabs[].path`; additional panes become `tabs[].panes`.
