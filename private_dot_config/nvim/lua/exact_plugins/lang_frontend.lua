-- LazyVim Extras provide Prettier, Biome, ESLint, VTSLS, Astro, Svelte, Prisma, and Tailwind.
-- Both Biome and Prettier remain enabled until Biome has full frontend filetype coverage.

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      -- nvim-lspconfig routes Deno projects to denols and Node projects to vtsls.
      -- TODO: this causes an extra Deno install because Deno's LSP is just `deno lsp`
      -- fix this and ensure mason isn't doing a secondary install if Deno is already available globally
      opts.servers.denols = {}
      opts.servers.emmet_language_server = {}
      opts.servers.graphql = {}
      return opts
    end,
  },
}
