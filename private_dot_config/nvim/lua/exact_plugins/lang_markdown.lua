local marksman_link_diagnostic_codes = {
  ["1"] = true,
  ["2"] = true,
}

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
      opts.formatters["markdown-toc"] = opts.formatters["markdown-toc"] or {}
      opts.formatters["markdown-toc"].append_args = { "--bullets", "-" }
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.markdown = { "rumdl", "markdown-toc" }
      opts.formatters_by_ft["markdown.mdx"] = { "rumdl", "markdown-toc" }
      return opts
    end,
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.markdown = { "rumdl" }
      opts.linters_by_ft["markdown.mdx"] = { "rumdl" }
      opts.linters = opts.linters or {}
      opts.linters.rumdl = { stream = "stdout" }
      return opts
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = vim.tbl_filter(function(tool)
        return tool ~= "markdownlint-cli2"
      end, opts.ensure_installed or {})
      table.insert(opts.ensure_installed, "rumdl")
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

      -- The girlOS vault has no .git/.marksman.toml, so requiring a workspace
      -- root keeps marksman out of the vault, where markdown-oxide and
      -- obsidian-ls serve markdown instead (see docs/obsidian.md)
      opts.servers.marksman.workspace_required = true

      local vault = require("config.vault")
      opts.servers.markdown_oxide = {
        capabilities = {
          -- oxide needs dynamic file-watch registration for live re-indexing
          -- and its create-unresolved-file code action
          workspace = { didChangeWatchedFiles = { dynamicRegistration = true } },
        },
        root_dir = function(bufnr, on_dir)
          if vault.buf_in_vault(bufnr) then
            on_dir(vault.root)
          end
        end,
        on_attach = function(_, bufnr)
          vim.lsp.codelens.enable(true, { bufnr = bufnr })
        end,
      }
      return opts
    end,
  },
  {
    "jakewvincent/mkdnflow.nvim",
    ft = { "markdown", "markdown.mdx", "quarto", "rmd" },
    opts = function(_, opts)
      opts.filetypes = opts.filetypes or {}
      opts.filetypes.mdx = "markdown.mdx"
      opts.filetypes.qmd = "quarto"

      opts.modules = opts.modules or {}
      opts.modules.folds = false

      opts.to_do = opts.to_do or {}
      opts.to_do.status_order = { "not_started", "complete" }
      opts.to_do.statuses = { complete = { marker = "x" } }

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

        vim.keymap.set("n", "<M-CR>", function()
          local mkdnflow = require("mkdnflow")
          local list_type = mkdnflow.lists.hasListType(vim.api.nvim_get_current_line())
          local row = vim.api.nvim_win_get_cursor(0)[1]
          if
            (list_type == "ultd" or list_type == "oltd")
            and not require("mkdnflow.utils").cursorInCodeBlock(row)
            and not mkdnflow.links.getLinkUnderCursor()
          then
            vim.cmd.MkdnToggleToDo()
          else
            vim.cmd.MkdnEnter()
          end
        end, { buffer = bufnr, desc = "Follow link or toggle checkbox" })
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
