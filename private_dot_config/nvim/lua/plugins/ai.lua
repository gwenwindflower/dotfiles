return {
  {
    "olimorris/codecompanion.nvim",
    version = "^19.0.0",
    opts = {
      interactions = {
        chat = {
          adapter = "opencode",
        },
        inline = {
          adapter = {
            name = "opencode_zen",
            model = "opencode/gpt-5.5",
          },
        },
        cmd = {
          adapter = {
            name = "opencode_zen",
            model = "opencode/gpt-5.3-codex",
          },
        },
        -- Cheap background tasks
        background = {
          adapter = {
            name = "opencode_zen",
            model = "opencode/gpt-5.4-mini",
          },
        },
        cli = {
          agent = "opencode",
          agents = {
            claude_code = {
              cmd = "claude",
              args = {},
              description = "Claude Code CLI",
              provider = "terminal",
            },
            opencode = {
              cmd = "opencode",
              args = {},
              description = "OpenCode TUI",
              provider = "terminal",
            },
          },
        },
      },
      adapters = {
        acp = {
          -- secondary ACP chat via Claude Max sub
          claude_code = function()
            return require("codecompanion.adapters").extend("claude_code", {
              env = {
                CLAUDE_CODE_OAUTH_TOKEN = "CLAUDE_CODE_ACP_OAUTH_TOKEN",
              },
              defaults = {
                mcpServers = "inherit_from_config",
              },
            })
          end,
          -- primary ACP chat backend
          opencode = function()
            return require("codecompanion.adapters").extend("opencode", {})
          end,
        },
        http = {
          -- OpenCode Zen OpenAI-compatible gateway, used for non-chat
          opencode_zen = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              name = "opencode_zen",
              formatted_name = "OpenCode Zen",
              env = {
                api_key = "OPENCODE_ZEN_API_KEY",
                url = "https://opencode.ai/zen",
                chat_url = "/v1/chat/completions",
                models_endpoint = "/v1/models",
              },
            })
          end,
        },
      },
      rules = {
        base_rules = {
          description = "Shared agent rules from ~/.agents/rules",
          files = {
            {
              path = "~/.agents/rules",
              files = "*.md",
            },
          },
        },
        opts = {
          chat = {
            -- Only load rules for HTTP adapters — ACP adapters
            -- (Claude Code, OpenCode) already load these through
            -- their own agent config
            ---@param chat CodeCompanion.Chat
            ---@return boolean
            condition = function(chat)
              return chat.adapter.type == "http"
            end,
          },
        },
      },
      prompt_library = {
        markdown = {
          dirs = {
            vim.fn.stdpath("config") .. "/codecompanion_prompts",
          },
        },
      },
      display = {
        action_palette = {
          width = 95,
          height = 10,
          provider = "snacks",
          opts = {
            show_default_actions = true,
            show_default_prompt_library = true,
          },
        },
      },
    },
    keys = {
      {
        "<Leader>ao",
        "<cmd>CodeCompanionChat Toggle<CR>",
        desc = "CodeCompanion Toggle",
        mode = { "n" },
      },
      {
        "<C-'>",
        "<cmd>CodeCompanionChat Toggle<CR>",
        desc = "CodeCompanion Toggle",
        mode = { "n" },
      },
      {
        "<Leader>ac",
        "<cmd>CodeCompanionCLI<CR>",
        desc = "CodeCompanion CLI",
        mode = { "n" },
      },
      {
        "<Leader>ak",
        "<cmd>CodeCompanionActions<CR>",
        desc = "Action Palette",
        mode = { "n" },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    lazy = true,
  },
  {
    "folke/sidekick.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.cli = {
        mux = {
          -- TODO: get this run `tmux_hint [tool]` when it launches
          backend = "tmux",
          create = "window",
          enabled = true,
        },
        win = {
          keys = {
            -- Pretty much all of the default Sidekick keybinds conflict with various agents,
            -- e.g. ctrl-p for prompts is used in the ctrl-n/p based scrolling in Cluade Code,
            -- so I've remapped everything to use alt/opt/meta + a mnemonic key where possible
            prompt = { "<m-p>", "prompt", mode = "t", desc = "Insert prompt or context" },
            -- a for '@' is the mnemonic, you @ files in most agents, and usually I'm
            -- @'ing an open buffer
            buffers = { "<m-a>", "buffers", mode = "t", desc = "Pick buffers to add" },
            -- f for 'files'/'fuzzy finder'
            files = { "<m-f>", "files", mode = "t", desc = "Pick files to add" },
            -- Escape to normal mode from within Claude Code terminal,
            -- ctrl-b was default, which is send to background in Claude Code,
            -- thankfully this seems to be unused across agents, which is nice because
            -- it's a critical keybinding for this workflow
            stopinsert = { "<c-w>", "stopinsert", mode = "t", desc = "Escape to normal mode" },
          },
        },
        prompts = {
          security = "Audit {file} for security issues including: input validation gaps, injection vulnerabilities (SQL, XSS, command), authentication/authorization flaws, unsafe data handling, and cryptographic weaknesses. Provide specific line numbers and remediation steps for each issue found. Current diagnostics for the file (may be empty): {diagnostics}",
          functional = "Refactor {file} toward functional programming principles: eliminate mutable state, extract pure functions, use immutable data structures, replace loops with map/filter/reduce, and minimize side effects. Preserve existing behavior while improving composability and testability.",
          class_design = "Analyze {class} design quality and suggest improvements: better names that reveal intent, cohesive responsibility alignment, appropriate encapsulation, clearer type signatures, removal of code smells (long methods, feature envy, data clumps), and adherence to SOLID principles where applicable.",
          clarify = "Review {file} for clarity and maintainability. Simplify complex logic, improve naming to be self-documenting, reduce cognitive load (nested conditionals, long functions), add strategic comments only where logic isn't self-evident, and restructure for better readability. Suggest specific refactorings with before/after examples.",
          teach = "Explain {selection} for someone new to this language. Break down: syntax and language-specific idioms, standard library APIs being used, design patterns or conventions, potential gotchas or common mistakes, and why this approach was chosen over alternatives. Use clear examples and relate to concepts from other languages where helpful.",
        },
      }
      return opts
    end,
  },
  -- minuet.nvim FIM completions
  -- {
  --   "milanglacier/minuet-ai.nvim",
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   -- Minuet stays unloaded until blink requires it
  --   -- which is gated by `vim.g.blink_minuet_enabled`
  --   -- toggles with <Leader>am
  --   -- see ux.lua and keymaps.lua for more details
  --   lazy = true,
  --   opts = {
  --     provider = "openai_fim_compatible",
  --     n_completions = 3,
  --     context_window = 100000,
  --     request_timeout = 4,
  --     throttle = 600,
  --     debounce = 200,
  --     after_cursor_filter_length = 15,
  --     provider_options = {
  --       openai_fim_compatible = {
  --         end_point = "https://api.deepseek.com/beta/completions",
  --         api_key = "DEEPSEEK_API_KEY",
  --         name = "DeepSeek",
  --         model = "deepseek-v4-flash",
  --         stream = true,
  --         optional = {
  --           max_tokens = 500,
  --           top_p = 0.9,
  --           extra_body = {
  --             thinking = { type = "disabled" },
  --           },
  --         },
  --       },
  --     },
  --     -- Using blink.cmp instead of direct virtualtext
  --     -- virtualtext = {
  --     --   auto_trigger_ft = { "*" },
  --     --   auto_trigger_ignore_ft = {
  --     --     "markdown",
  --     --     "gitcommit",
  --     --     "TelescopePrompt",
  --     --     "snacks_picker_input",
  --     --     "CodeCompanion",
  --     --   },
  --     --   keymap = {
  --     --     accept = "<A-A>",
  --     --     accept_line = "<A-a>",
  --     --     accept_n_lines = "<A-z>",
  --     --     prev = "<A-[>",
  --     --     next = "<A-]>",
  --     --     dismiss = "<A-e>",
  --     --   },
  --     -- },
  --   },
  -- },
}
