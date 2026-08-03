-- The Markdown LazyVim Extra supplies conform.nvim (running markdownlint-cli2), marksman, and nvim-lint (running markdownlint-cli2)
-- for formatting, LSP, and linting Markdown files.
-- We add logic to use the global ~/.markdownlint.yaml config file if no local config is found.
-- Otherwise, use the local config file found in the current working directory or any parent directory.
local markdownlint_config_names = {
  ".markdownlint-cli2.jsonc",
  ".markdownlint-cli2.yaml",
  ".markdownlint-cli2.cjs",
  ".markdownlint-cli2.mjs",
  ".markdownlint.jsonc",
  ".markdownlint.json",
  ".markdownlint.yaml",
  ".markdownlint.yml",
  ".markdownlint.cjs",
  ".markdownlint.mjs",
}
local default_markdownlint_config = vim.fs.normalize("~/.markdownlint.yaml")
local markdownlint_config_by_dir = {}

local function markdownlint_config(dirname)
  local config = markdownlint_config_by_dir[dirname]
  if not config then
    config = vim.fs.find(markdownlint_config_names, { path = dirname, upward = true })[1] or default_markdownlint_config
    markdownlint_config_by_dir[dirname] = config
  end
  return config
end

local function markdownlint_config_args(_, ctx)
  local config = markdownlint_config(ctx.dirname)
  return { "--config", config }
end

local function current_markdownlint_config()
  return markdownlint_config(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
end

return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters = opts.formatters or {}
      opts.formatters["markdownlint-cli2"] = opts.formatters["markdownlint-cli2"] or {}
      opts.formatters["markdownlint-cli2"].append_args = markdownlint_config_args
      return opts
    end,
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters = opts.linters or {}
      opts.linters["markdownlint-cli2"] = opts.linters["markdownlint-cli2"] or {}
      opts.linters["markdownlint-cli2"].args = { "--config", current_markdownlint_config, "-" }
      return opts
    end,
  },
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = function(_, opts)
  --     opts.servers = opts.servers or {}
  --     opts.servers.harper_ls = {
  --       filetypes = {
  --         "asciidoc",
  --         "codecompanion",
  --         "gitcommit",
  --         "json",
  --         "json5",
  --         "jsonc",
  --         "markdown",
  --         "sidekick_terminal",
  --         "text",
  --         "tex",
  --         "toml",
  --         "typst",
  --         "yaml",
  --       },
  --     }
  --     return opts
  --   end,
  -- },
  -- {
  --   "obsidian-nvim/obsidian.nvim",
  --   version = "*",
  --   ft = "markdown",
  --   dependencies = { "nvim-lua/plenary.nvim", "saghen/blink.cmp" },
  --   opts = {
  --     legacy_commands = false,
  --     frontmatter = {
  --       enabled = false,
  --     },
  --     workspaces = {
  --       {
  --         name = "girlOS",
  --         path = os.getenv("OBSIDIAN_DEFAULT_VAULT"),
  --       },
  --       -- {
  --       --   name = "cwd",
  --       --   path = function()
  --       --     return assert(vim.fn.getcwd())
  --       --   end,
  --       --   overrides = {
  --       --     notes_subdir = vim.NIL,
  --       --     new_notes_location = "current_dir",
  --       --     disable_frontmatter = true,
  --       --   },
  --       -- },
  --     },
  --     completion = { blink = true, min_chars = 2 },
  --     picker = { name = "snacks.picker" },
  --   },
  -- }
}
