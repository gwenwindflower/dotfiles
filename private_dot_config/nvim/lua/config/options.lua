-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Use HEAD of main branch for blink instead of frozen LazyVim fork
vim.g.lazyvim_blink_main = true

-- avoid Biome conflicting with Prettier
-- bc still some file types that Biome doesn't support yet
-- this only triggers Prettier in Confrom if a prettierrc
-- exists in the workspace
vim.g.lazyvim_prettier_needs_config = true

-- Set the spellfile explicitly to the standard path so we can add rare words
-- zg works a bit more magically, it will create a spellfile here if doesn't exist
-- spellrare will not, so it fails if this is not specified
vim.opt.spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"

-- Personally defined var for toggling minuet as a blink source
-- See plugins/ai.lua for details
-- vim.g.blink_minuet_enabled = false
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
})
vim.g.ai_cmp = false
