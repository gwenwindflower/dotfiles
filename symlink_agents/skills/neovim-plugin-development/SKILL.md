---
name: neovim-plugin-development
description: Write Neovim plugins in Lua with lazy.nvim compatibility. Covers vim.api, plugin structure, health checks, lazy.nvim integration (opts, pkg, dependencies, build, lazy-loading), testing with busted, and common patterns for commands, autocommands, floating windows, and async.
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
├── lazy.lua              -- Recommended spec for lazy.nvim pkg system
└── Makefile              -- make test
```

### Config Pattern

```lua
-- lua/my-plugin/config.lua
local M = {}

M.defaults = {
  option1 = true,
  option2 = "default",
}

M.options = vim.deepcopy(M.defaults)

function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})
end

return M
```

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

Most Neovim users install plugins via [lazy.nvim](https://lazy.folke.io). Design plugins to work well with its conventions.

### The `opts` Convention

lazy.nvim calls `require("my-plugin").setup(opts)` automatically when you use the `opts` key in a spec. **Always prefer `opts` over `config`** — `config` is almost never needed:

```lua
-- User's plugin spec (this is what they write, not what you ship)
{ "user/my-plugin.nvim", opts = { option1 = false } }

-- lazy.nvim automatically calls:
-- require("my-plugin").setup({ option1 = false })
```

This works out of the box if your plugin exports `M.setup(opts)`. No extra lazy.nvim-specific code needed in the plugin itself.

### Shipping a `lazy.lua`

Include a `lazy.lua` at your plugin root to declare the recommended spec for your plugin. lazy.nvim's [pkg system](https://lazy.folke.io/packages) auto-detects this file and merges it into the user's spec. The plugin identifier (`"user/my-plugin.nvim"`) is required as the first positional element:

```lua
-- lazy.lua (at plugin root)
return {
  "user/my-plugin.nvim",
  cmd = { "MyCommand" },
}
```

This tells lazy.nvim how to best load your plugin without the user needing to figure out the right events or commands.

### Pkg Source Priority

lazy.nvim checks package sources in order — first match wins:

1. `lazy.lua` (recommended)
2. `*-scm-1.rockspec` (luarocks native packages)
3. `pkg.json` (experimental packspec)

The `lazy.lua` approach covers most plugins. Rockspec is for plugins that need C compilation or have non-Lua dependencies. Rockspec files are also auto-detected as a `build` source when a plugin lacks a `/lua` directory.

### Dependencies

Only declare `dependencies` when a plugin must be installed AND loaded before yours. **Lua libraries don't need explicit dependencies** — they load automatically when `require()`d:

```lua
-- DO: declare deps that must be loaded first
{ "user/my-plugin.nvim", dependencies = { "nvim-telescope/telescope.nvim" } }

-- DON'T: declare pure Lua libraries as deps (they auto-load on require)
-- { "user/my-plugin.nvim", dependencies = { "nvim-lua/plenary.nvim" } }  -- unnecessary
```

Mark pure library dependencies as `lazy = true` if you do list them, so they defer loading until actually required.

### Build Steps

The `build` property runs after install/update. Options:

```lua
return {
  "user/my-plugin.nvim",
  build = ":TSUpdate",           -- Neovim command (prefixed with ":")
  -- build = "make",             -- shell command
  -- build = "rockspec",         -- luarocks make
  -- build = function(plugin)    -- Lua function (async coroutine)
  --   coroutine.yield("Building...")  -- report progress
  -- end,
  -- build = { "make", ":TSUpdate" }, -- multiple steps (list)
}
```

If your plugin includes a `build.lua` at the root, lazy.nvim auto-detects and runs it.

**Important**: Build functions run in parallel with other plugin builds. Never change the working directory — it affects other concurrent builds. Use `vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h")` to get your build file's directory instead.

### Lazy-Loading Triggers

Design plugins so users can lazy-load them. Expose clear entry points:

```lua
return {
  "user/my-plugin.nvim",
  cmd = { "MyCommand" },           -- load on command
  event = { "BufReadPost" },       -- load on event
  ft = { "lua", "python" },        -- load on filetype
  keys = { { "<leader>x", ... } }, -- load on keymap
}
```

If your plugin creates user commands in `setup()`, those commands become natural lazy-load triggers via `cmd`.

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
