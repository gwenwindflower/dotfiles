return {
  -- Tombi replaces the Taplo server provided by LazyVim's TOML Extra.
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.tombi = {}
      return opts
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.zizmor = {}
      opts.servers.gh_actions_ls = {}
      return opts
    end,
  },
}
