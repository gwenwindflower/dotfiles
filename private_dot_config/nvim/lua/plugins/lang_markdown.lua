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
local marksman_link_diagnostic_codes = {
  ["1"] = true,
  ["2"] = true,
}

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

local function is_chezmoi_source_root(root)
  if not root then
    return false
  end

  return vim.uv.fs_stat(vim.fs.joinpath(root, ".chezmoi.toml.tmpl")) ~= nil
    and vim.uv.fs_stat(vim.fs.joinpath(root, ".chezmoiignore")) ~= nil
end

local function filter_chezmoi_marksman_diagnostics(next_handler)
  return function(error, result, context, config)
    local client = vim.lsp.get_client_by_id(context.client_id)
    if result and is_chezmoi_source_root(client and client.root_dir) then
      result = vim.deepcopy(result)
      result.diagnostics = vim.tbl_filter(function(diagnostic)
        return not marksman_link_diagnostic_codes[tostring(diagnostic.code)]
      end, result.diagnostics or {})
    end

    return next_handler(error, result, context, config)
  end
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
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.marksman = opts.servers.marksman or {}
      opts.servers.marksman.handlers = opts.servers.marksman.handlers or {}

      local method = "textDocument/publishDiagnostics"
      local handler = opts.servers.marksman.handlers[method] or vim.lsp.handlers[method]
      opts.servers.marksman.handlers[method] = filter_chezmoi_marksman_diagnostics(handler)
      return opts
    end,
  },
  {
    "jakewvincent/mkdnflow.nvim",
    ft = { "markdown", "rmd" },
    opts = function(_, opts)
      opts.modules = opts.modules or {}
      opts.modules.folds = false

      opts.mappings = opts.mappings or {}
      local mappings = opts.mappings
      mappings.MkdnEnter = { { "i", "n", "v" }, "<M-CR>" }
      mappings.MkdnGoBack = { "n", "<C-,>" }
      mappings.MkdnGoForward = { "n", "<C-.>" }
      mappings.MkdnNextLink = { "n", "<M-Tab>" }
      mappings.MkdnPrevLink = { "n", "<M-S-Tab>" }
      mappings.MkdnMoveSource = { "n", "<LocalLeader>mlm" }
      mappings.MkdnDestroyLink = { "n", "<LocalLeader>mld" }
      mappings.MkdnTagSpan = { "v", "<LocalLeader>mls" }
      mappings.MkdnYankAnchorLink = { "n", "<LocalLeader>mla" }
      mappings.MkdnYankFileAnchorLink = { "n", "<LocalLeader>mlf" }
      mappings.MkdnCreateLinkFromClipboard = { { "n", "v" }, "<leader>P" }
      mappings.MkdnUpdateNumbering = { "n", "<LocalLeader>mi" }
      mappings.MkdnTableNextRow = false
      mappings.MkdnTablePrevRow = { "i", "<M-S-CR>" }
      mappings.MkdnTableNewRowBelow = { "n", "<LocalLeader>mTr" }
      mappings.MkdnTableNewRowAbove = { "n", "<LocalLeader>mTR" }
      mappings.MkdnTableNewColAfter = { "n", "<LocalLeader>mTc" }
      mappings.MkdnTableNewColBefore = { "n", "<LocalLeader>mTC" }
      mappings.MkdnTableDeleteRow = { "n", "<LocalLeader>mTdr" }
      mappings.MkdnTableDeleteCol = { "n", "<LocalLeader>mTdc" }
      mappings.MkdnTableAlignLeft = { "n", "<LocalLeader>mTal" }
      mappings.MkdnTableAlignRight = { "n", "<LocalLeader>mTar" }
      mappings.MkdnTableAlignCenter = { "n", "<LocalLeader>mTac" }
      mappings.MkdnTableAlignDefault = { "n", "<LocalLeader>mTax" }
      mappings.MkdnTab = { "i", "<M-Tab>" }
      mappings.MkdnSTab = { "i", "<M-S-Tab>" }
      mappings.MkdnIndentListItem = { "i", "<M-.>" }
      mappings.MkdnDedentListItem = { "i", "<M-,>" }
      mappings.MkdnTableNextCell = false
      mappings.MkdnTablePrevCell = false
      mappings.MkdnIncreaseHeading = false
      mappings.MkdnDecreaseHeading = false
      mappings.MkdnIncreaseHeadingOp = false
      mappings.MkdnDecreaseHeadingOp = false
      mappings.MkdnToggleToDo = false
      mappings.MkdnFoldSection = false
      mappings.MkdnUnfoldSection = false

      local on_attach = opts.on_attach
      opts.on_attach = function(bufnr)
        if type(on_attach) == "function" then
          on_attach(bufnr)
        end

        vim.keymap.set({ "n", "x", "i" }, "<D-CR>", "<M-CR>", {
          buffer = bufnr,
          desc = "Contextual enter",
          remap = true,
        })
        vim.keymap.set("n", "<M-,>", "<<", { buffer = bufnr, desc = "Dedent line" })
        vim.keymap.set("n", "<M-.>", ">>", { buffer = bufnr, desc = "Indent line" })
        vim.keymap.set("n", "<LocalLeader>mt", "<cmd>MkdnTableFormat<cr>", {
          buffer = bufnr,
          desc = "Format table",
        })

        require("which-key").add({
          { "<LocalLeader>m", group = "markdown", mode = { "n", "x" }, buffer = bufnr },
          { "<LocalLeader>ml", group = "links", mode = { "n", "x" }, buffer = bufnr },
          { "<LocalLeader>mT", group = "tables", mode = "n", buffer = bufnr },
        })
      end

      return opts
    end,
  },
}
