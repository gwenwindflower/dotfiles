return {
  -- Load type definitions for the plugin APIs customized most often.
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
}
