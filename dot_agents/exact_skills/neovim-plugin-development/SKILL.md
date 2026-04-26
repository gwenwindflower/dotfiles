---
name: neovim-plugin-development
description: Write Neovim plugins in Lua compatible with lazy.nvim: vim.api, plugin layout, health checks, lazy-loading, busted tests, floating windows, async. Use when authoring a Neovim plugin or its lazy.nvim spec. Skip for editing personal nvim config (use neovim-config).
---

# Neovim Plugin Development

Write Neovim plugins in Lua, from internal APIs to shipping a lazy.nvim-compatible package.

## When to Use This Skill

- Writing custom Neovim plugin logic (not just configuration)
- Structuring a plugin for distribution (lazy.nvim pkg, health checks, vimdoc)
- Working with vim.api, vim.fn, vim.opt directly
- Understanding how existing plugins work internally
- Creating buffer manipulation, window management, or custom UI
- Implementing autocommands, user commands, or highlight groups
- Debugging Lua code running inside Neovim

## Core APIs

### vim.api (Neovim API)

Primary interface for Neovim internals:

```lua
-- Buffers
vim.api.nvim_get_current_buf()
vim.api.nvim_buf_get_lines(buf, start, end_, strict)
vim.api.nvim_buf_set_lines(buf, start, end_, strict, lines)
vim.api.nvim_buf_get_name(buf)
vim.api.nvim_buf_set_option(buf, name, value)  -- deprecated, use vim.bo
vim.api.nvim_buf_get_mark(buf, name)

-- Windows
vim.api.nvim_get_current_win()
vim.api.nvim_win_get_buf(win)
vim.api.nvim_win_set_cursor(win, {row, col})
vim.api.nvim_win_get_cursor(win)  -- returns {row, col}, 1-indexed row
vim.api.nvim_open_win(buf, enter, config)  -- floating windows

-- Commands and keymaps
vim.api.nvim_create_user_command(name, command, opts)
vim.api.nvim_create_autocmd(event, opts)
vim.api.nvim_set_keymap(mode, lhs, rhs, opts)

-- Namespaces (for highlights, extmarks)
vim.api.nvim_create_namespace(name)
vim.api.nvim_buf_add_highlight(buf, ns, hl_group, line, col_start, col_end)
vim.api.nvim_buf_set_extmark(buf, ns, line, col, opts)
```

### vim.fn (Vimscript Functions)

Access Vimscript functions from Lua:

```lua
vim.fn.expand("%:p")           -- full path of current file
vim.fn.fnamemodify(path, ":t") -- filename only
vim.fn.filereadable(path)      -- returns 1 or 0
vim.fn.glob(pattern)           -- file globbing
vim.fn.system(cmd)             -- run shell command
vim.fn.json_decode(str)
vim.fn.json_encode(table)
vim.fn.input("Prompt: ")       -- user input
vim.fn.confirm("Question?", "&Yes\n&No")
```

### vim.opt / vim.o / vim.bo / vim.wo

```lua
-- Global options
vim.opt.number = true
vim.o.number = true  -- direct access

-- Buffer-local options
vim.bo.filetype = "lua"
vim.bo[bufnr].modifiable = false

-- Window-local options
vim.wo.wrap = false
vim.wo[winnr].signcolumn = "yes"

-- Option with list/map operations
vim.opt.wildignore:append({ "*.o", "*.a" })
vim.opt.listchars = { tab = ">> ", trail = "-" }
```

### vim.keymap

```lua
vim.keymap.set("n", "<leader>x", function()
  -- inline function
end, { desc = "Description", buffer = bufnr, silent = true })

vim.keymap.del("n", "<leader>x")
```

## Plugin Structure

### Minimal Plugin

```lua
-- lua/my-plugin/init.lua
local M = {}

M.setup = function(opts)
  opts = opts or {}
  -- Initialize plugin with user options
end

return M
```

### Full Plugin Structure

```text
my-plugin.nvim/
├── lua/
│   └── my-plugin/
│       ├── init.lua      -- Main entry, exports M.setup()
│       ├── config.lua    -- Default config, merged with user opts
│       ├── health.lua    -- :checkhealth my-plugin
│       ├── commands.lua  -- User commands
│       └── util.lua      -- Helper functions
├── plugin/
│   └── my-plugin.lua     -- Auto-loaded, guard with vim.g.loaded_my_plugin
├── tests/
│   ├── run.lua           -- Busted test runner (nvim -l tests/run.lua)
│   └── *_spec.lua        -- Test files
├── doc/
│   └── my-plugin.txt     -- Help documentation (:help my-plugin)
├── lazy.lua              -- Pkg spec: tells lazy.nvim this plugin needs setup()
└── Makefile              -- make test
```

### Config Pattern

`config.lua` defines your plugin's defaults — the keys users override via `opts` in their lazy spec. The full flow:

1. You define a local `defaults` table in `config.lua` — your plugin's full configuration surface
2. User writes `opts = { notify = false }` in their lazy spec
3. lazy.nvim calls `require("my-plugin").setup({ notify = false })`
4. `init.lua` delegates to `config.setup(opts)`, which merges user opts over defaults

Only define keys that control **plugin behavior**. Do NOT put lazy.nvim spec fields (`event`, `cmd`, `keys`, `ft`) in your defaults — those control when lazy.nvim loads the plugin, not how it behaves. They belong in the user's spec or the `lazy.lua` pkg spec.

```lua
-- lua/my-plugin/config.lua
local M = {}

-- Local defaults, not exposed directly. Users never touch this table —
-- they configure the plugin through opts in their lazy spec.
local defaults = {
  enabled = true,
  notify = true,
  some_dir = "~/.config/my-plugin",
}

-- Module-local merged config, accessed via __index metatable below
local config = vim.deepcopy(defaults)

function M.setup(opts)
  config = vim.tbl_deep_extend("force", {}, vim.deepcopy(defaults), opts or {})

  -- Commands, autocmds, and other initialization go here — not in init.lua.
  -- This keeps init.lua as a thin delegation layer.
  vim.api.nvim_create_user_command("MyCommand", function(args)
    require("my-plugin.commands").run(args)
  end, { nargs = "?", desc = "My Plugin" })
end

-- Metatable allows direct access: require("my-plugin.config").notify
setmetatable(M, {
  __index = function(_, key)
    return config[key]
  end,
})

return M
```

```lua
-- lua/my-plugin/init.lua — thin shell, delegates to config
local M = {}

function M.setup(opts)
  require("my-plugin.config").setup(opts)
end

return M
```

This pattern comes from folke's plugins (flash.nvim, sidekick.nvim). `init.lua` is a thin entry point — `config.lua` owns defaults, merging, command registration, and exposes the merged config via `__index`.

### Health Check

Implement `lua/my-plugin/health.lua` so users can run `:checkhealth my-plugin`. Use this to verify external dependencies, config validity, and runtime state:

```lua
local M = {}

M.check = function()
  vim.health.start("my-plugin")

  -- Check external tool dependency
  if vim.fn.executable("some-tool") == 1 then
    vim.health.ok("`some-tool` found")
  else
    vim.health.error("`some-tool` not found", { "Install: https://..." })
  end

  -- Check config directory exists
  local cfg = require("my-plugin.config").options
  local dir = vim.fn.expand(cfg.some_dir)
  if vim.fn.isdirectory(dir) == 1 then
    vim.health.ok("directory exists: " .. dir)
  else
    vim.health.warn("directory not found: " .. dir, { "Create it or update config" })
  end
end

return M
```

Health checks are especially important for plugins that shell out to external tools or depend on specific directory structures.

## lazy.nvim Integration

Most Neovim users install plugins via [lazy.nvim](https://lazy.folke.io). Design plugins to work well with its conventions. See [lazy.folke.io/developers](https://lazy.folke.io/developers) for full reference.

### Two specs, two roles

There are two places a lazy.nvim spec can live, and understanding the boundary between them is critical:

1. **`lazy.lua` at the plugin repo root** (the "pkg spec") — shipped by the plugin author. Declares the minimal spec needed for the plugin to work: `opts = {}` if setup() is required, `cmd` for lazy-load triggers, `dependencies`, `build` steps. This is the plugin's baseline.
2. **User's spec in their nvim config** (e.g. `lua/plugins/my-plugin.lua`) — written by the user. Adds their own `opts`, `event`, `keys`, etc. lazy.nvim deep-merges the user's spec on top of the pkg spec.

The plugin author controls what the plugin *needs*. The user controls *when and how* it loads. Keep these concerns separate.

### The `lazy.lua` pkg spec

If your plugin exports `M.setup(opts)`, ship a `lazy.lua` at the repo root so lazy.nvim knows to call it. lazy.nvim's [pkg system](https://lazy.folke.io/packages) auto-detects this file and merges it with the user's spec.

```lua
-- lazy.lua (at plugin root) — minimal example
return {
  "user/my-plugin.nvim",
  opts = {},
}
```

The `opts = {}` is the key part — it tells lazy.nvim "call `require('my-plugin').setup(opts)` when this plugin loads." Without it, lazy.nvim loads the plugin files but never calls `setup()`.

A more complete example with lazy-load triggers:

```lua
return {
  "user/my-plugin.nvim",
  cmd = { "MyCommand", "MyOtherCommand" },
  opts = {},
}
```

**What belongs in lazy.lua vs the user's spec:**

| Concern | lazy.lua (plugin author) | User spec |
| --- | --- | --- |
| `opts = {}` (enable setup) | Yes | Override with their values |
| `cmd` (command triggers) | Yes, if plugin creates commands | Can add more |
| `event` / `keys` / `ft` | Rarely — user's choice | Yes |
| `dependencies` | Only if required for function | Can add their own |
| `build` | Yes, if plugin needs build steps | Can override |

**Do not** put `event`, `keys`, or `ft` in `lazy.lua` unless the plugin fundamentally requires loading on a specific event to function. Those are user preferences about load timing.

**Do not** put plugin-internal config keys (like custom options your plugin defines) in `lazy.lua` spec fields. Plugin config belongs in `config.lua` defaults, merged via `opts`. Spec fields like `event`, `cmd`, `keys` are lazy.nvim concepts — they control *when lazy.nvim loads the plugin*, not how the plugin behaves internally.

### The `opts` convention

When a spec has `opts` (table or function), lazy.nvim calls `require("my-plugin").setup(opts)` automatically. Always prefer `opts` over `config`:

```lua
-- GOOD: opts — lazy.nvim handles merging and calling setup()
{ "user/my-plugin.nvim", opts = { option1 = false } }

-- BAD: config — prevents opts merging from multiple specs
{
  "user/my-plugin.nvim",
  config = function()
    require("my-plugin").setup({ option1 = false })
  end,
}
```

When multiple specs exist for the same plugin (e.g. pkg spec + user spec), `opts` tables are deep-merged automatically. Using `config` instead breaks this merging.

### Dependencies

Only declare `dependencies` when a plugin must be installed AND loaded before yours. Lua libraries auto-load on `require()` — they don't need to be declared as dependencies:

```lua
-- GOOD: separate specs, plenary loads on demand
{ "user/my-plugin.nvim", opts = {} },
{ "nvim-lua/plenary.nvim", lazy = true },

-- BAD: forces plenary to load immediately when my-plugin loads
{
  "user/my-plugin.nvim",
  opts = {},
  dependencies = { "nvim-lua/plenary.nvim" },
}
```

### Build steps

The `build` property runs after install/update:

```lua
return {
  "user/my-plugin.nvim",
  build = ":TSUpdate",              -- Neovim command (prefix ":")
  -- build = "make",                -- shell command
  -- build = "rockspec",            -- luarocks make
  -- build = function(plugin) end,  -- Lua function (async coroutine)
  -- build = { "make", ":TSUpdate" }, -- multiple steps
}
```

If a `build.lua` exists at the plugin root, lazy.nvim auto-detects and runs it. Build functions run in parallel — never change the working directory.

## Common Patterns

### Autocommands

```lua
local group = vim.api.nvim_create_augroup("MyPlugin", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  pattern = "*.lua",
  callback = function(args)
    -- args.buf, args.file, args.match available
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "MyPluginEvent",
  callback = function() ... end,
})

-- Trigger custom event
vim.api.nvim_exec_autocmds("User", { pattern = "MyPluginEvent" })
```

### User Commands

```lua
vim.api.nvim_create_user_command("MyCommand", function(opts)
  -- opts.args, opts.fargs, opts.bang, opts.line1, opts.line2, opts.range
  print(opts.args)
end, {
  nargs = "*",      -- 0, 1, *, ?, +
  bang = true,
  range = true,
  complete = function(arglead, cmdline, cursorpos)
    return { "option1", "option2" }
  end,
})
```

### Floating Windows

```lua
local buf = vim.api.nvim_create_buf(false, true)  -- nofile, scratch
vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Line 1", "Line 2" })

local win = vim.api.nvim_open_win(buf, true, {
  relative = "editor",
  width = 40,
  height = 10,
  row = 5,
  col = 10,
  style = "minimal",
  border = "rounded",
})

-- Close with q
vim.keymap.set("n", "q", function()
  vim.api.nvim_win_close(win, true)
end, { buffer = buf })
```

### Extmarks and Virtual Text

```lua
local ns = vim.api.nvim_create_namespace("my-plugin")

-- Virtual text at end of line
vim.api.nvim_buf_set_extmark(buf, ns, line, 0, {
  virt_text = { { "virtual text", "Comment" } },
  virt_text_pos = "eol",
})

-- Clear namespace
vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
```

### Async with vim.schedule

```lua
-- Defer to main loop (required when calling from callbacks)
vim.schedule(function()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end)

-- Debounce pattern
local timer = vim.loop.new_timer()
local function debounce(fn, ms)
  return function(...)
    local args = { ... }
    timer:stop()
    timer:start(ms, 0, vim.schedule_wrap(function()
      fn(unpack(args))
    end))
  end
end
```

## Testing

Test Neovim plugins with busted, running inside headless Neovim via `nvim -l`. Busted must be installed for the LuaJIT 5.1 ABI — C modules compiled against other Lua versions won't load.

```bash
luarocks --local --lua-version=5.1 install busted
```

### Test Runner

Create `tests/run.lua` to bootstrap rtp, luarocks paths, and invoke busted. Run with `nvim -l tests/run.lua`. For the full runner template and Neovim-specific testing patterns, see [testing_with_busted.md](testing_with_busted.md).

### lazy.minit (for tests needing other plugins)

lazy.nvim ships `lazy.minit.busted()` — bootstraps lazy.nvim, installs listed specs, then runs busted:

```lua
-- tests/busted.lua
#!/usr/bin/env -S nvim -l
vim.env.LAZY_STDPATH = ".tests"
load(vim.fn.system("curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua"))()

require("lazy.minit").busted({
  spec = {
    "nvim-telescope/telescope.nvim",  -- test-time deps
  },
})
```

Run with: `nvim -l ./tests/busted.lua tests`

### Reproduction Scripts

Ship a `repro.lua` for users to reproduce issues in a clean environment:

```lua
-- repro.lua
vim.env.LAZY_STDPATH = ".repro"
load(vim.fn.system("curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua"))()
require("lazy.minit").repro({
  spec = {
    "user/my-plugin.nvim",
  },
})
```

Run with: `nvim -u repro.lua`

## Debugging

```lua
-- Print inspection
print(vim.inspect(table))
vim.print(table)  -- shorthand

-- Notifications
vim.notify("Message", vim.log.levels.INFO)
vim.notify("Error!", vim.log.levels.ERROR)

-- Check value
assert(condition, "Error message")

-- Debug print to file
local f = io.open("/tmp/nvim-debug.log", "a")
f:write(vim.inspect(data) .. "\n")
f:close()
```

## Guidelines

- Use `vim.schedule` when modifying buffers from async callbacks
- Clear autocommand groups before recreating to avoid duplicates
- Use namespaces for highlights/extmarks to enable clean removal
- Prefer `vim.keymap.set` over `vim.api.nvim_set_keymap`
- Use `vim.tbl_deep_extend` for merging config tables
- Check `vim.fn.has("nvim-0.10")` for version-specific features
- Test with `:luafile %` or `:source %` during development
- Use `:messages` and `:checkhealth` for debugging
