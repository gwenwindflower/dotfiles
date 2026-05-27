return {
  -- Shell
  -- LazyVim installs fish linter and formatter by default,
  -- but LSP and Treesitter grammar need to be explicitly installed
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "fish")
      return opts
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.fish_lsp = {}
      return opts
    end,
  },
  -- GraphQL
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.graphql = {}
      return opts
    end,
  },
  -- TypeScript/Frontend
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      -- denols will attach to files in directories containing deno.json or deno.jsonc,
      -- while vtsls handles Node/npm projects (package.json, tsconfig.json)
      -- this is disambiguated in the nvim-lspconfig default setup
      opts.servers.denols = {}
      -- this is a less 'official' but better emmet lsp, it has better tag-chaining specifically
      opts.servers.emmet_language_server = {}
      return opts
    end,
  },
  -- Go
  -- This should let agents attach to the gopls instance MCP server
  -- but it doesn't seem to work, need to look into, low priority
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = function(_, opts)
  --     opts.servers = opts.servers or {}
  --     opts.servers.gopls = opts.servers.gopls or {}
  --     -- gopls recently added an MCP server that exposes
  --     -- the LSP output as tools for agents
  --     -- so we set this to use that
  --     -- instead of just `gopls` (which is equivalent to `gopls serve`)
  --     opts.servers.gopls.cmd = {
  --       "gopls",
  --       "serve",
  --       "-mcp.listen=localhost:8092",
  --     }
  --   end,
  -- },
  -- Lua
  ---- It's helpful for plugins with lots of config to be able to
  ---- pull in their type definitions for checking with LuaLS
  ---- particularly stuff from folke and others heavily in the LazyVim ecosystem
  ---- who are very rigorous about their type annotations, which I also happen
  ---- to use and customize the most
  --- TODO: add overseer
  {
    "folke/lazydev.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.library = opts.library or {}
      table.insert(opts.library, { path = "sidekick.nvim", words = { "Sidekick" } })
      table.insert(
        opts.library,
        { path = vim.fs.normalize("~/.config/yazi/plugins/types.yazi"), words = { "ya", "Yazi" } }
      )
      return opts
    end,
  },
  -- TOML (I prefer tombi to LazyVim's default TOML Extra which uses taplo)
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.tombi = {}
      return opts
    end,
  },
  -- GitHub Actions
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.zizmor = {}
      opts.servers.gh_actions_ls = {}
      return opts
    end,
  },
  -- Markdown
  {
    "mzlogin/vim-markdown-toc",
    ft = { "markdown" },
    cmd = { "GenTocGFM", "GenTocRedcarpet", "GenTocGitLab", "GenTocMarked", "UpdateToc", "RemoveToc" },
    init = function()
      vim.g.vmt_auto_update_on_save = 1
      vim.g.vmt_cycle_list_item_markers = 1
      vim.g.vmt_list_item_char = "-"
      vim.g.vmt_fence_text = "TOC"
      vim.g.vmt_fence_closing_text = "/TOC"
    end,
  },
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
  -- },
  -- {
  --   "tadmccorkle/markdown.nvim",
  --   ft = "markdown",
  --   opts = {},
  -- },
}

-- Handled by LazyVim defaults: most Lua stuff, *some* basic shell stuff

-- Handled by LazyVim Extras:

---- Most TypeScript / Frontend

---- NOTE: Currently running both Biome and Prettier extras until Biome
---- has full frontend filetype coverage, examine this more closely

------ Frameworks: Astro, Svelte
------ ORMs: Prisma
------ CSS: Tailwind

---- Go

---- Python
---- Confiured in options.lua to use Ruff for everything

---- Rust

---- SQL
---- TODO: Not sure aout this extra, should roll my own

---- Text: Markdown (LazyExtra enabled)

---- Config: JSON, YAML
