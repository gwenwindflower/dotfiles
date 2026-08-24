-- TODO: set up projects and sessions tooling
return {
  {
    "gwenwindflower/provisions.nvim",
    opts = {
      env_dirs = { "~/.config/op/environments" },
    },
  },
  -- Alignment tools
  -- TODO: figure out how the hell this works,
  -- my mental model of it is terrible and i can never
  -- get it to do what I want
  {
    "nvim-mini/mini.align",
    version = "*",
    opts = {
      mappings = {
        start = "<LocalLeader>na",
        start_with_preview = "<LocalLeader>np",
      },
      options = {
        split_pattern = " ",
        justify_side = "left",
        merge_delimiter = "",
        modifiers = {
          i = true, -- ignore comment patterns
          [" "] = true, -- better space delimiting (ignores multiple spaces)
        },
      },
    },
  },
  -- Add % to autopairs when in curly brackets as I use {% %} a lot
  {
    "nvim-mini/mini.pairs",
    opts = function(_, opts)
      opts = opts or {}
      opts.mappings = vim.tbl_extend("force", opts.mappings or {}, {
        ["%"] = { action = "closeopen", pair = "%%", neigh_pattern = "{" },
        ["#"] = { action = "closeopen", pair = "##", neigh_pattern = "{" },
      })
      return opts
    end,
  },
  -- Snippet tool
  {
    "chrisgrieser/nvim-scissors",
    dependencies = "folke/snacks.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.snippetSelection = opts.snippetSelection or {}
      opts.snippetSelection.picker = "snacks"
      opts.snippetDir = vim.fn.stdpath("config") .. "/snippets"
      opts.backdrop = opts.backdrop or {}
      opts.backdrop.enabled = false
      opts.editSnippetPopup = opts.editSnippetPopup or {}
      opts.editSnippetPopup.border = "rounded"
      return opts
    end,
    keys = {
      { "<LocalLeader>sa", "<cmd>ScissorsAddNewSnippet<cr>", mode = { "n", "x" }, desc = "Create new snippet" },
      { "<LocalLeader>se", "<cmd>ScissorsEditSnippet<cr>", mode = { "n" }, desc = "Edit snippet" },
    },
  },
  -- Treesitter grammar for vhs files
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "vhs")
      return opts
    end,
  },
  -- Obsidian vault tooling, scoped to girlOS (see docs/obsidian.md)
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    ft = "markdown",
    cmd = "Obsidian",
    init = function()
      -- markdown-oxide owns completion/rename/references/definition in the
      -- vault; obsidian-ls keeps only its code actions (templates, properties)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("obsidian_ls_defers_to_oxide", { clear = true }),
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if not client or client.name ~= "obsidian-ls" then
            return
          end
          client.server_capabilities.completionProvider = nil
          client.server_capabilities.renameProvider = nil
          client.server_capabilities.referencesProvider = nil
          client.server_capabilities.definitionProvider = nil
        end,
      })
    end,
    opts = {
      legacy_commands = false,
      workspaces = {
        { name = "girlos", path = require("config.vault").root },
      },
      picker = { name = "snacks.picker" },
      -- render-markdown.nvim owns markdown rendering
      ui = { enable = false },
      -- rematter owns frontmatter; obsidian must not rewrite it on save
      frontmatter = { enabled = false },
      checkbox = { order = { " ", "/", "x" } },
      daily_notes = {
        folder = "day",
        template = "periodic/Daily",
      },
      templates = { folder = "_templates" },
      attachments = { folder = "_media" },
      note_id_func = function(title)
        return title or tostring(os.time())
      end,
      callbacks = {
        enter_note = function()
          local bufnr = vim.api.nvim_get_current_buf()
          local map = function(mode, lhs, rhs, desc, opts)
            opts = opts or {}
            opts.buffer = bufnr
            opts.desc = desc
            vim.keymap.set(mode, lhs, rhs, opts)
          end

          -- Contextual enter matches mkdnflow's chord outside the vault;
          -- insert-mode <M-CR> stays mkdnflow list continuation
          map("n", "<M-CR>", require("obsidian.actions").smart_action, "Obsidian smart action", { expr = true })
          map("x", "<M-CR>", ":Obsidian link_new<cr>", "Link selection to new note")

          -- Vault link jumps land in the jumplist, not mkdnflow's history
          map("n", "<C-,>", "<C-o>", "Jump back")
          map("n", "<C-.>", "<C-i>", "Jump forward")

          -- Shadows MkdnMoveSource, which would break wikilink backlinks
          map("n", "<LocalLeader>mlm", "<cmd>Obsidian rename<cr>", "Rename note (update backlinks)")

          map("n", "<LocalLeader>ob", "<cmd>Obsidian backlinks<cr>", "Backlinks")
          map("n", "<LocalLeader>ot", "<cmd>Obsidian tags<cr>", "Tags")
          map("n", "<LocalLeader>od", "<cmd>Obsidian today<cr>", "Today's daily note")
          map("n", "<LocalLeader>oD", "<cmd>Obsidian dailies<cr>", "Daily notes picker")
          map("n", "<LocalLeader>oo", "<cmd>Obsidian quick_switch<cr>", "Quick switch note")
          map("n", "<LocalLeader>os", "<cmd>Obsidian search<cr>", "Search vault")
          map("n", "<LocalLeader>or", "<cmd>Obsidian rename<cr>", "Rename note")
          map("n", "<LocalLeader>on", "<cmd>Obsidian new<cr>", "New note")
          map("n", "<LocalLeader>oN", "<cmd>Obsidian new_from_template<cr>", "New note from template")
          map("n", "<LocalLeader>op", "<cmd>Obsidian template<cr>", "Insert template")
          map("n", "<LocalLeader>oi", "<cmd>Obsidian paste_img<cr>", "Paste image")
          map("n", "<LocalLeader>oc", "<cmd>Obsidian toc<cr>", "Table of contents")
          map("n", "<LocalLeader>ol", "<cmd>Obsidian links<cr>", "Links in note")
          map("x", "<LocalLeader>ol", ":Obsidian link<cr>", "Link selection to existing note")
          map("x", "<LocalLeader>ox", ":Obsidian extract_note<cr>", "Extract selection to note")

          require("which-key").add({
            { "<LocalLeader>o", group = "obsidian", mode = { "n", "x" }, buffer = bufnr },
          })
        end,
      },
    },
  },
}
