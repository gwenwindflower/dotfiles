# Testing Neovim Plugins with Busted

Test Neovim plugins using busted inside headless Neovim via `nvim -l`. Busted requires Lua >= 5.1 and must be installed for the LuaJIT 5.1 ABI — Neovim uses LuaJIT internally, so C modules compiled against Lua 5.4/5.5 will fail to load.

## Installation

```bash
luarocks --local --lua-version=5.1 install busted
```

If `luarocks path` outputs nothing useful for LuaJIT, the test runner must manually prepend `~/.luarocks/share/lua/5.1/` and `~/.luarocks/lib/lua/5.1/` to `package.path` and `package.cpath`.

## Test Runner Setup

### Option A: Self-contained runner (recommended for plugins without other plugin deps)

Create `tests/run.lua` — bootstraps rtp, luarocks paths, and invokes busted:

```lua
-- tests/run.lua — execute with: nvim -l tests/run.lua
local plugin_root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h")
vim.opt.rtp:prepend(plugin_root)
package.path = plugin_root .. "/lua/?.lua;" .. plugin_root .. "/lua/?/init.lua;" .. package.path

vim.o.swapfile = false
vim.opt.shadafile = "NONE"

-- Detect luarocks Lua version dynamically
local home = os.getenv("HOME")
local rocks_root = home .. "/.luarocks"
for _, entry in ipairs(vim.fn.glob(rocks_root .. "/share/lua/*", false, true)) do
  local ver = vim.fn.fnamemodify(entry, ":t")
  if ver:match("^%d+%.%d+$") then
    local share = rocks_root .. "/share/lua/" .. ver
    local lib = rocks_root .. "/lib/lua/" .. ver
    package.path = share .. "/?.lua;" .. share .. "/?/init.lua;" .. package.path
    package.cpath = lib .. "/?.so;" .. lib .. "/?.dylib;" .. package.cpath
    break
  end
end

arg = { "--directory=" .. plugin_root, "--pattern=_spec", "--ROOT=tests/", "--output=utfTerminal" }
require("busted.runner")({ standalone = false })
```

### Option B: lazy.minit bootstrap (for plugins needing other plugins in test env)

lazy.nvim ships `lazy.minit.busted()` which bootstraps lazy.nvim itself, installs listed plugin specs, then runs busted. Create `tests/busted.lua`:

```lua
#!/usr/bin/env -S nvim -l
vim.env.LAZY_STDPATH = ".tests"
load(vim.fn.system("curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua"))()

require("lazy.minit").busted({
  spec = {
    "nvim-lua/plenary.nvim",  -- list test-time deps here
  },
})
```

Run with: `nvim -l ./tests/busted.lua tests`

This approach downloads lazy.nvim on first run, caches to `.tests/`, and handles plugin installation. Good for integration tests that need telescope, treesitter, etc.

### Makefile

```makefile
.PHONY: test

test:
	nvim -l tests/run.lua
```

## Project Layout

```text
my-plugin.nvim/
├── lua/my-plugin/
│   ├── init.lua
│   └── config.lua
├── tests/
│   ├── run.lua              # test runner
│   ├── config_spec.lua      # config tests
│   └── my_plugin_spec.lua   # core tests
├── .busted                  # optional busted config
└── Makefile
```

Busted finds test files by pattern match (default `_spec`). Put them all in `tests/`.

## Test Syntax

### Structure

```lua
describe("module name", function()
  local mod

  before_each(function()
    -- Runs before each it() in this describe block.
    -- Reload modules for isolation:
    package.loaded["my-plugin"] = nil
    mod = require("my-plugin")
  end)

  after_each(function()
    -- Cleanup after each it()
  end)

  -- One-time setup/teardown for the entire describe block:
  setup(function() end)
  teardown(function() end)

  describe("nested group", function()
    it("does something", function()
      assert.equals("expected", mod.thing())
    end)
  end)
end)
```

`context` is an alias for `describe`. `spec` and `test` are aliases for `it`.

### Pending

```lua
pending("not implemented yet")

it("skipped for now", function()
  pending("blocked on upstream fix")
end)
```

### Insulate and Expose

`insulate` creates a sandbox — restores `_G` and `package.loaded` after the block. `expose` is the opposite — leaks changes to subsequent blocks. Useful for controlling module reload behavior across test groups.

```lua
insulate("isolated group", function()
  require("some-module")  -- unloaded after this block
end)
```

## Assertions

### Equality

```lua
assert.equals(expected, actual)       -- reference equality (==)
assert.same(expected, actual)         -- deep table comparison
assert.is_not.equals(a, b)
```

### Truthiness

```lua
assert.is_true(val)                   -- strictly boolean true
assert.is_false(val)                  -- strictly boolean false
assert.truthy(val)                    -- not nil and not false
assert.falsy(val)                     -- nil or false
assert.is_nil(val)
assert.is_not_nil(val)
```

### Types

```lua
assert.is_string(val)
assert.is_number(val)
assert.is_table(val)
assert.is_function(val)
assert.is_boolean(val)
```

### Errors

```lua
assert.has_error(function() error("boom") end)
assert.has_error(fn, "expected message")
assert.has_no.errors(function() end)
```

### Modifiers

Chain with `is`, `is_not`, `are`, `are_not`, `has`, `has_no`:

```lua
assert.is.truthy(val)
assert.is_not.equals(a, b)
assert.has_no.errors(fn)
```

Lua keywords need underscores: `assert.is_true()`, `assert.is_not_nil()`, `assert.is_not_false()`.

## Spies, Stubs, and Mocks

### Spies — wrap functions, track calls, preserve behavior

```lua
local s = spy.new(function(x) return x + 1 end)
s(42)
assert.spy(s).was.called()
assert.spy(s).was.called(1)            -- called exactly once
assert.spy(s).was.called_with(42)

-- Spy on existing table method
spy.on(t, "method_name")
t:method_name("arg")
assert.spy(t.method_name).was.called_with(match.is_ref(t), "arg")
s:revert()                             -- restore original
```

### Stubs — replace functions, don't execute them

```lua
stub(t, "method_name")
t.method_name("arg")                   -- does NOT execute original
assert.stub(t.method_name).was.called_with("arg")
t.method_name:revert()
```

### Mocks — wrap entire tables

```lua
local m = mock(t)                      -- all methods become spies
local m = mock(t, true)                -- all methods become stubs
mock.revert(m)
```

### Matchers

```lua
local match = require("luassert.match")
assert.spy(s).was_called_with(match._)             -- any value
assert.spy(s).was_called_with(match.is_string())
assert.spy(s).was_called_with(match.is_same({ a = 1 }))
```

## Neovim-Specific Testing Patterns

### Reloading modules between tests

Neovim's `require()` caches modules in `package.loaded`. To test setup/config in isolation, clear and re-require in `before_each`:

```lua
before_each(function()
  package.loaded["my-plugin"] = nil
  package.loaded["my-plugin.config"] = nil
  local plugin = require("my-plugin")
  plugin.setup({ option = "test-value" })
end)
```

### Testing user commands

User commands are global Neovim state — they persist across module reloads. Clean up in tests that assert command absence:

```lua
it("does not create command when disabled", function()
  pcall(vim.api.nvim_del_user_command, "MyCommand")
  plugin.setup({ create_user_command = false })
  local cmds = vim.api.nvim_get_commands({})
  assert.is_nil(cmds.MyCommand)
end)
```

### Testing autocmds

Use `vim.api.nvim_get_autocmds()` to verify registration without firing them:

```lua
it("registers a BufWritePre autocmd", function()
  plugin.setup({})
  local acs = vim.api.nvim_get_autocmds({ event = "BufWritePre", group = "MyPluginGroup" })
  assert.truthy(#acs > 0)
end)
```

### Testing with temp files

Use `vim.fn.tempname()` for disposable test directories:

```lua
it("finds profiles in directory", function()
  local dir = vim.fn.tempname()
  vim.fn.mkdir(dir, "p")

  local f = io.open(dir .. "/test.env", "w")
  f:write("KEY=val\n")
  f:close()

  plugin.setup({ base_dir = dir })
  local profiles = plugin.list_profiles()
  assert.equals(1, #profiles)

  vim.fn.delete(dir, "rf")
end)
```

### Exposing internals for testing

Add a `_internal` table to expose local utility functions without polluting the public API:

```lua
-- init.lua
local function trim(s) return ((s or ""):gsub("^%s+", ""):gsub("%s+$", "")) end

M._internal = { trim = trim }
return M
```

This avoids the `_G._TEST` pattern (which busted docs suggest) — `_internal` is cleaner and doesn't require global flag coordination.

### Async operations

`vim.system()` callbacks and `vim.schedule()` run outside the synchronous test flow. For unit tests, focus on testing the synchronous parts (parsing, validation, config). For integration tests that must exercise async paths, consider `vim.wait()`:

```lua
it("sets env var after op inject", function()
  plugin.load_profile("test")
  local ok = vim.wait(2000, function()
    return vim.env.MY_SECRET ~= nil
  end, 50)
  assert.is_true(ok)
end)
```

## Tags and Filtering

Tag tests by adding `#tag` to describe/it strings:

```lua
describe("parser #unit", function() ... end)
describe("op inject #integration", function() ... end)
```

Run subsets:

```bash
nvim -l tests/run.lua -- --tags=unit
nvim -l tests/run.lua -- --exclude-tags=integration
```

## .busted Config

Optional project-level config at repo root:

```lua
return {
  _all = {
    lpath = "lua/?.lua;lua/?/init.lua",
  },
  default = {
    verbose = true,
  },
  unit = {
    tags = "unit",
    ROOT = { "tests/" },
  },
}
```

Run a named task: `busted --run=unit`

## What to Test in a Neovim Plugin

Focus test effort where it provides the most value:

- **Config merging**: defaults, user overrides, nil handling, immutability of defaults table
- **Pure utility functions**: string parsing, validation, path construction
- **Input validation**: profile names, event names, type checking, path traversal prevention
- **User command creation**: conditional creation, argument handling, completion
- **Error paths**: missing dependencies, invalid input, missing files — verify no unhandled errors
- **Autocmd registration**: verify correct event/group/pattern, one-shot behavior

Async operations (shell commands, timers) and UI (floating windows, highlights) are harder to test in headless mode. Prefer testing the synchronous logic around them.
