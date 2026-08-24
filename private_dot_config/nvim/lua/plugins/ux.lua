return {
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>e", false },
      { "<leader>E", false },
      {
        "<leader>fe",
        false,
      },
      {
        "<leader>fE",
        false,
      },
      {
        "<leader>e",
        function()
          Snacks.explorer({ cwd = LazyVim.root() })
        end,
        desc = "Explorer Snacks (root dir)",
      },
      {
        "<leader>E",
        function()
          Snacks.explorer()
        end,
        desc = "Explorer Snacks (cwd)",
      },
    },
  },
  -- herdr splits integration
  {
    "lmilojevicc/herdr-splits.nvim",
    -- For local development, swap the repo line for `dir = '/path/to/herdr-splits/local/plugin'`
    cond = vim.env.HERDR_ENV == "1",
    event = "VeryLazy",
    build = ":lua require('herdr-splits').sync_herdr()",
    opts = {
      resize_keys = { left = "<C-left>", down = "<C-down>", up = "<C-up>", right = "<C-right>" },
      auto_sync_herdr = true,
    },
    keys = {
      {
        "<C-h>",
        function()
          require("herdr-splits").move_cursor_left()
        end,
        desc = "Navigate left",
      },
      {
        "<C-j>",
        function()
          require("herdr-splits").move_cursor_down()
        end,
        desc = "Navigate down",
      },
      {
        "<C-k>",
        function()
          require("herdr-splits").move_cursor_up()
        end,
        desc = "Navigate up",
      },
      {
        "<C-l>",
        function()
          require("herdr-splits").move_cursor_right()
        end,
        desc = "Navigate right",
      },
      {
        "<C-left>",
        function()
          require("herdr-splits").resize_left()
        end,
        desc = "Resize left",
      },
      {
        "<C-down>",
        function()
          require("herdr-splits").resize_down()
        end,
        desc = "Resize down",
      },
      {
        "<C-up>",
        function()
          require("herdr-splits").resize_up()
        end,
        desc = "Resize up",
      },
      {
        "<C-right>",
        function()
          require("herdr-splits").resize_right()
        end,
        desc = "Resize right",
      },
    },
  },
  -- Yazi integration
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>fe",
        mode = { "n" },
        "<cmd>Yazi<cr>",
        desc = "Explorer Yazi (file)",
      },
      {
        "<leader>fE",
        mode = { "n" },
        "<cmd>Yazi cwd<cr>",
        desc = "Explorer Yazi (cwd)",
      },
      {
        "<D-f>",
        mode = { "n" },
        "<cmd>Yazi<cr>",
        desc = "Explorer Yazi (file)",
      },
      {
        "<D-F>",
        mode = { "n" },
        "<cmd>Yazi cwd<cr>",
        desc = "Explorer Yazi (cwd)",
      },
    },
    opts = {
      integrations = {
        fzf = true,
        grep_in_directory = "snacks.picker",
        grep_in_selected_files = "snacks.picker",
        picker_add_copy_relative_path_action = "snacks.picker",
        resolve_relative_path_application = "realpath",
      },
      resolve_relative_path_application = "grealpath",
      keymaps = {
        show_help = "<m-?>",
      },
    },
  },
  -- Noice
  {
    "folke/noice.nvim",
    opts = {
      presets = {
        bottom_search = false,
        lsp_doc_border = true,
      },
    },
  },
  {
    "saghen/blink.cmp",
    -- blink.cmp v2 (main branch) split blink.lib into its own repo;
    -- LazyVim's blink_main extra doesn't add it yet.
    -- lazy.nvim concatenates for the `dependencies` key
    -- so we just configure our additions
    dependencies = { { "saghen/blink.lib" } },
    -- v2 replaces the cargo build with a build/download orchestrator
    build = function()
      require("blink.cmp").build():wait(60000)
    end,
    opts = {
      completion = {
        menu = {
          border = "rounded",
          auto_show = function()
            return vim.bo.filetype ~= "markdown"
          end,
        },
        documentation = {
          window = { border = "rounded" },
        },
        -- stop blink from firing constant completions requests through minuet
        -- trigger = { prefetch_on_insert = false },
        list = {
          selection = {
            preselect = function()
              -- if you're inside a snippet, tab/shift-tab jumps through arguments
              -- don't treat this as an 'accept' action for the completion menu
              -- example: snippet with 3 args, you fill out all 3, realize arg 1 was wrong
              -- shift-tab back to 1, then realize arg 2 needs to be updated as well
              -- you don't want that second tab through from 1 to 2 within the already active snippet
              -- to trigger the completion menu selection
              return not require("blink.cmp").snippet_active({ direction = 1 })
            end,
            auto_insert = false,
          },
        },
      },
      -- sources = {
      --   default = { "minuet" },
      --   providers = {
      --     minuet = {
      --       name = "minuet",
      --       module = "minuet.blink",
      --       score_offset = 100,
      --       async = true,
      --       timeout_ms = 2000,
      --       -- Source-level gate: when off, blink never requires minuet.blink,
      --       -- so lazy.nvim doesn't load minuet, and minuet's backend module
      --       -- never runs its load-time `is_available` env var check.
      --       -- This prevents Minuet reaching for `DEEPSEEK_API_KEY` when Provisions
      --       -- potentially hasn't made it available yet, which can cause Minuet
      --       -- to error and quit trying to load completely for the session
      --       -- Using <Leader>am ensures the env var is available
      --       -- loading it via Provisions if needed
      --       -- then flips this variable
      --       enabled = function()
      --         return vim.g.blink_minuet_enabled == true
      --       end,
      --     },
      --   },
      -- },
      signature = { window = { border = "rounded" } },
      keymap = {
        preset = "super-tab",
        -- I use C-space as tmux prefix
        -- so add this as an alternate option for when I'm in tmux
        ["<M-space>"] = { "show", "show_documentation", "hide_documentation" },
        -- ["<M-m>"] = {
        --   function(cmp)
        --     cmp.show({ providers = { "minuet" } })
        --   end,
        -- },
      },
    },
  },
  {
    "folke/flash.nvim",
    keys = {
      {
        -- I use C-space as tmux prefix
        -- so add this as an alternate option for when I'm in tmux
        "<M-space>",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter({
            actions = {
              ["<M-space>"] = "next",
              ["<BS>"] = "prev",
            },
          })
        end,
        desc = "Treesitter Incremental Selection",
      },
    },
  },
  -- Snacks picker, I try as much as possible to standardize all picker/search previews
  -- as using ctrl-p and ctrl-n to scroll the preview pane up and down
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts or {}, {
        picker = {
          win = {
            input = {
              keys = {
                ["<c-p>"] = { "preview_scroll_up", mode = { "i", "n" } },
                ["<c-n>"] = { "preview_scroll_down", mode = { "i", "n" } },
              },
            },
            list = {
              keys = {
                ["<c-p>"] = { "preview_scroll_up", mode = { "i", "n" } },
                ["<c-n>"] = { "preview_scroll_down", mode = { "i", "n" } },
              },
            },
          },
          ui_select = true,
          prompt = " ",
        },
        input = {
          icon = " ",
        },
        lazygit = {
          theme = {
            activeBorderColor = { fg = "rainbow6", bold = true },
            searchingActiveBorderColor = { fg = "rainbow5", bold = true },
          },
        },
      })
    end,
  },
  -- super cool plugin for reactive highlighting, i haven't dug very deep yet,
  -- just using these presets, but they are already very cool
  -- {
  --   "rasulomaroff/reactive.nvim",
  --   opts = {
  --     load = { "catppuccin-frappe-cursor", "catppuccin-frappe-cursorline" },
  --   },
  -- },
  -- Rounding borders on key plugin windows to match the flat UI aesthetic
  -- Note: lazy.nvim border config is in lua/config/lazy.lua (can't be configured via plugin spec)
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.ui = opts.ui or {}
      opts.ui.border = "rounded"
      return opts
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "hasansujon786/nvim-navbuddy",
        dependencies = {
          "SmiteshP/nvim-navic",
          "MunifTanjim/nui.nvim",
        },
        opts = {
          window = {
            border = "rounded",
          },
          lsp = { auto_attach = true },
          source_buffer = {
            follow_node = true,
            highlight = true,
          },
        },
        cmd = {
          "Navbuddy",
        },
        keys = {
          { "<leader>cd", mode = { "n" }, "<cmd>Navbuddy<cr>", desc = "Open Navbuddy overlay" },
        },
      },
    },
  },
  {
    "sphamba/smear-cursor.nvim",
    opts = {
      never_draw_over_target = true,
      hide_target_hack = true,
      stiffness = 0.5,
      trailing_stiffness = 0.4,
      damping = 0.8,
      cursor_color = "#F4B8E4",
    },
  },
}
