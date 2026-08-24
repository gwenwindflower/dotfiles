-- Single source of truth for the girlOS Obsidian vault location.
-- Consumed by the obsidian.nvim spec (plugins/utils.lua) and the markdown
-- LSP scoping in plugins/lang_markdown.lua. See docs/obsidian.md.
local M = {}

M.root =
  vim.fs.normalize(vim.env.OBSIDIAN_DEFAULT_VAULT or "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/girlOS")

function M.contains(path)
  return vim.startswith(vim.fs.normalize(path), M.root)
end

function M.buf_in_vault(bufnr)
  return M.contains(vim.api.nvim_buf_get_name(bufnr))
end

return M
