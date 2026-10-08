return {
  -- LazyVim installs the Fish linter and formatter, while its LSP and Treesitter grammar need explicit setup.
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
}
