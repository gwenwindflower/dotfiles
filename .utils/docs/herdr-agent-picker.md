# Herdr Agent Picker

The Herdr agent picker opens a Catppuccin Frappé-themed popup, collects an agent and model with `gum choose`, asks for effort when the agent supports it, then creates a focused tab in the active workspace and starts the selected agent there. Tab naming belongs to the heraldry plugin; call it explicitly to set or reset a tab name.

Use either binding:

```text
prefix+a
shift+super+a
```

`prefix+a` is the portable core binding for every environment. `shift+super+a` is the direct macOS shortcut, following the same convention as new-tab and keeping Herdr's direct bindings in the Shift-Super modifier space.

## Components

| Source | Deployed target | Responsibility |
| --- | --- | --- |
| `private_dot_config/herdr/agent-picker.sh` | `~/.config/herdr/agent-picker.sh` | Shared Gum theme, tab creation, and launch behavior |
| `private_dot_config/herdr/executable_pick-agent` | `~/.config/herdr/pick-agent` | Top-level Codex, Claude, or OpenCode selection |
| `private_dot_config/herdr/executable_pick-codex-agent` | `~/.config/herdr/pick-codex-agent` | Codex model and effort choices plus native argument construction |
| `private_dot_config/herdr/executable_pick-claude-agent` | `~/.config/herdr/pick-claude-agent` | Claude model and effort choices plus native argument construction |
| `private_dot_config/herdr/executable_pick-opencode-agent` | `~/.config/herdr/pick-opencode-agent` | OpenCode Zen model choices for the v2 `opencode2 mini` interface |
| `private_dot_config/herdr/executable_open-nvim` | `~/.config/herdr/open-nvim` | Focused nvim tab creation in the active pane directory |
| `symsources/herdr/config.toml` | `~/.config/herdr/config.toml` | Popup dimensions and launcher bindings |

The shared `launch_agent` function owns the Herdr interaction:

1. Read the active workspace and pane cwd from Herdr's custom-command environment.
2. Create and focus an unlabeled tab in that workspace, leaving the name to heraldry.
3. Parse the root pane ID from `.result.root_pane.pane_id`.
4. Serialize the agent executable and native arguments as a shell-safe command.
5. Submit the command with `pane run`, which returns without waiting for agent readiness.

The popup closes as soon as the command reaches the new pane, while MCP loading and authentication continue visibly in the focused tab. Herdr detects the manually launched agent without assigning it a live-agent alias; target it by pane ID when later automation needs to address it.

The agent-specific scripts own the hard-coded supported choices. `default` omits the corresponding native override so the agent reads its normal configuration. Codex receives `-m` and `model_reasoning_effort`; Claude receives `--model` and `--effort`; OpenCode receives only `-m`, because its selected Zen models expose different variant systems instead of one shared effort scale.

OpenCode launches through the v2 `opencode2 mini` interface. Its curated Zen list covers Kimi K3, GLM-5.2, DeepSeek V4 Pro, DeepSeek V4 Flash, and Ling 3.0 Flash Fin Free. Ling fills the fast-small role with 5.1B active parameters and high-throughput inference for latency-sensitive work.

Cancelling any chooser exits the popup before a tab is created.

## Editor Tab

`prefix+e` runs `~/.config/herdr/open-nvim`, which creates a focused tab in the active workspace at the active pane's cwd, then launches `nvim` in its root pane. The launcher does not provide a tab label; heraldry derives the name from the running editor and project context.

## Maintenance

Edit the model and effort lists in the corresponding agent script. Keep values aligned with the installed agent CLI:

```text
codex --help
claude --help
opencode2 --help
```

OpenCode Zen changes more frequently than the native Codex and Claude model sets. Confirm its current IDs against `https://opencode.ai/zen/v1/models` before editing `pick-opencode-agent`.

Validate and deploy changes from the repository root:

```text
shellcheck -e SC1091 private_dot_config/herdr/agent-picker.sh private_dot_config/herdr/executable_pick-* private_dot_config/herdr/executable_open-nvim
HERDR_CONFIG_PATH="$PWD/symsources/herdr/config.toml" herdr config check
chezmoi --dry-run --no-pager apply -n --verbose ~/.config/herdr
chezmoi apply ~/.config/herdr/agent-picker.sh ~/.config/herdr/pick-agent ~/.config/herdr/pick-codex-agent ~/.config/herdr/pick-claude-agent ~/.config/herdr/pick-opencode-agent ~/.config/herdr/open-nvim
herdr server reload-config
```

The shared library is copied without execute permission. Each picker uses the `executable_` source attribute and deploys as an executable.

## Tests

The behavior suite lives at `.utils/herdr-agent-picker_test.ts` and runs through the `.utils` task registry:

```text
cd .utils
deno task test:herdr-agent-picker
```

The tests materialize the chezmoi source files into a temporary target directory and replace Gum and Herdr with controlled executables. They verify:

- The top-level picker dispatches to the selected agent picker.
- The active workspace and cwd, including spaces, reach `tab create` unchanged.
- `tab create` carries no label, so heraldry owns the tab name.
- The root pane returned by `tab create` becomes the `pane run` target.
- Codex model and effort selections become native Codex arguments.
- Claude supports Haiku and passes its native effort argument.
- Codex models appear as Default, Sol, Luna, then Terra.
- OpenCode uses `opencode2 mini`, passes a Zen model, and does not ask for effort.
- Configured defaults omit native overrides.
- Cancelling the picker creates no Herdr tab or agent.
- The nvim launcher preserves the active workspace and pane directory.

Add behavior at the command boundary rather than asserting source text or file presence. A test should fail when the launched tab or agent arguments would be wrong for the user.

## Local Plugin Evolution

The shell launcher is the right shape while the picker remains a short, stateless sequence over fixed choices. Keep it here when new work only adds another agent, model, effort level, or color.

A local plugin becomes useful when the launcher needs one or more plugin-owned capabilities:

- Saved presets, favorites, recent selections, or user-editable picker state.
- Dynamic model discovery or provider-specific capability constraints.
- Rich model descriptions, previews, cost information, or validation before launch.
- Herdr event handling, metadata reporting, or coordination after an agent starts.
- A native popup entrypoint with structured argv and plugin context.
- Enough internal behavior to benefit from a dedicated configuration and state directory.

At that point, move the implementation and its tests together under `.utils/`:

```text
.utils/herdr-agent-picker/
├── herdr-plugin.toml
├── agent-picker.sh
├── pick-agent
├── pick-codex-agent
├── pick-claude-agent
├── pick-opencode-agent
├── open.sh
└── agent-picker_test.ts
```

The manifest should expose a popup pane entrypoint for the interactive picker and an `open` action for the global keybinding. Herdr keybindings invoke plugin actions, while the action opens the plugin-owned popup pane. The main config would retain only:

```toml
[[keys.command]]
key = ["prefix+a", "shift+super+a"]
type = "plugin_action"
command = "agent-picker.open"
description = "choose and launch agent"
```

Link the local plugin from its source directory during development:

```text
herdr plugin link .utils/herdr-agent-picker
```

Keep the plugin local until its configuration, behavior, and installation contract are useful outside this dotfiles repository. A local plugin does not need marketplace packaging, release automation, or a separate repository.

References:

- [Herdr custom command keybindings](https://herdr.dev/docs/configuration/#custom-command-keybindings)
- [Herdr agent automation](https://herdr.dev/docs/agent-automation/)
- [Herdr plugins](https://herdr.dev/docs/plugins/)
- [Gum](https://github.com/charmbracelet/gum)
