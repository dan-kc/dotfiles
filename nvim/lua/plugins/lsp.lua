local icons = require("config.icons")
return {
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                      nvim-lspconfig                      │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/nvim-cmp",
      -- "folke/neodev.nvim",
      "b0o/schemastore.nvim",
    },
    event = "VeryLazy",
    config = function(_, _)
      local lspconfig = require("lspconfig")
      local border = {
        { icons.border.rounded[1], "LspPreviewBorder" },
        { icons.border.rounded[2], "LspPreviewBorder" },
        { icons.border.rounded[3], "LspPreviewBorder" },
        { icons.border.rounded[4], "LspPreviewBorder" },
        { icons.border.rounded[5], "LspPreviewBorder" },
        { icons.border.rounded[6], "LspPreviewBorder" },
        { icons.border.rounded[7], "LspPreviewBorder" },
        { icons.border.rounded[8], "LspPreviewBorder" },
      }
      local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
      function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or border
        return orig_util_open_floating_preview(contents, syntax, opts, ...)
      end

      -- brew install lua_ls
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
          },
        },
      })

      -- npm install -g typescript-language-server
      lspconfig.tsserver.setup({
        settings = {
          javascript = {
            format = { enable = false },
            inlayHints = {
              includeInlayEnumMemberValueHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
              includeInlayParameterNameHintsWhenArgumentMatchesName = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayVariableTypeHints = true,
            },
          },
          typescript = {
            format = { enable = false },
            inlayHints = {
              includeInlayEnumMemberValueHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
              includeInlayParameterNameHintsWhenArgumentMatchesName = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayVariableTypeHints = true,
            },
          },
          tsserver_file_preferences = {
            quotePreference = "auto",
            importModuleSpecifierEnding = "js",
            jsxAttributeCompletionStyle = "auto",
            allowTextChangesInNewFiles = true,
            providePrefixAndSuffixTextForRename = true,
            allowRenameOfImportPath = true,
            includeAutomaticOptionalChainCompletions = true,
            provideRefactorNotApplicableReason = true,
            generateReturnInDocTemplate = true,
            includeCompletionsForImportStatements = true,
            includeCompletionsWithSnippetText = true,
            includeCompletionsWithClassMemberSnippets = true,
            includeCompletionsWithObjectLiteralMethodSnippets = true,
            useLabelDetailsInCompletionEntries = true,
            allowIncompleteCompletions = true,
            displayPartsForJSDoc = true,
            disableLineTextInReferences = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = true,
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
          commands = {
            blah = {
              bloo = "",
            },
          },
        },
      })

      -- brew install rust_analyzer
      lspconfig.rust_analyzer.setup({})

      -- go install gopls
      lspconfig.gopls.setup({
        settings = {
          gopls = {
            codelenses = {
              gc_details = false,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            analyses = {
              fieldalignment = true,
              nilness = true,
              unusedparams = true,
              unusedwrite = true,
              useany = true,
            },
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,
            directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
            semanticTokens = true,
          },
        },
      })

      -- no install
      require("lspconfig").jsonls.setup({
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })

      -- brew install llvm
      require("lspconfig").clangd.setup({})

      -- npm install -g @tailwindcss/language-server
      lspconfig.tailwindcss.setup({
        settings = {
          tailwindcss = {
            filetypes_exclude = { "markdown" },
          },
        },
      })

      -- brew install yamlls
      lspconfig.yamlls.setup({
        settings = {
          yaml = {
            keyOrdering = false,
          },
          schemaStore = {
            enable = false,
            url = "",
          },
          schemas = require("schemastore").yaml.schemas(),
        },
      })

      -- brew install marksman
      lspconfig.marksman.setup({})

      -- npm i -g vscode-langservers-extracted
      lspconfig.eslint.setup({
        on_attach = function(_, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
          })
        end,
      })

      -- go install github.com/bufbuild/buf-language-server/cmd/bufls@latest
      lspconfig.bufls.setup({})

      return {
        diagnostics = {
          underline = false,
          update_in_insert = false,
          virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = "●",
            -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
            -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
            -- prefix = "icons",
          },
          severity_sort = true,
        },
        -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the inlay hints.
        inlay_hints = {
          enabled = true,
        },
        format = {
          formatting_options = nil,
          timeout_ms = nil,
        },
      }
    end,
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                         nvim-cmp                         │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim",
    },
    keys = {
      -- {
      --   "<C-a>",
      --   mode = { "i" },
      --   function()
      --     require("cmp").complete()
      --   end,
      --   desc = "Autocomplete",
      -- },
    },
    opts = function()
      local cmp = require("cmp")
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local defaults = require("cmp.config.default")()
      local lspkind = require("lspkind")
      return {
        -- completion = {
        --   completeopt = "menu,menuone,preview,noinsert",
        --   autocomplete = true,
        -- },
        formatting = {
          format = lspkind.cmp_format({
            mode = "text_symbol", -- 'text', 'text_symbol', 'symbol_text', 'symbol'
            maxwidth = 80,
            ellipsis_char = "...",
            menu = {
              nvim_lsp = "[LSP]",
              path = "[PATH]",
              nvim_lua = "[LUA]",
              buffer = "[BUF]",
              luasnip = "[SNIP]",
            },
            symbol_map = {
              Text = "󰉿",
              Method = "󰆧",
              Function = "󰊕",
              Constructor = "",
              Field = "󰜢",
              Variable = "󰀫",
              Class = "󰠱",
              Interface = "",
              Module = "",
              Property = "󰜢",
              Unit = "󰑭",
              Value = "󰎠",
              Enum = "",
              Keyword = "󰌋",
              Snippet = "",
              Color = "󰏘",
              File = "󰈙",
              Reference = "󰈇",
              Folder = "󰉋",
              EnumMember = "",
              Constant = "󰏿",
              Struct = "󰙅",
              Event = "",
              Operator = "󰆕",
              TypeParameter = "",
            },
          }),
        },
        matching = {
          disallow_fuzzy_matching = false,
          disallow_fullfuzzy_matching = false,
          disallow_partial_fuzzy_matching = false,
          disallow_partial_matching = false,
          disallow_prefix_unmatching = false,
        },
        window = {
          completion = {
            border = {
              { icons.border.rounded[1] },
              { icons.border.rounded[2] },
              { icons.border.rounded[3] },
              { icons.border.rounded[4] },
              { icons.border.rounded[5] },
              { icons.border.rounded[6] },
              { icons.border.rounded[7] },
              { icons.border.rounded[8] },
            },
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
            scrolloff = 1,
            col_offset = 0,
            side_padding = 0,
            scrollbar = false,
          },
          documentation = cmp.config.window.bordered(),
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-CR>"] = cmp.mapping.confirm(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp", keyword_length = 1 },
          { name = "path", keyword_length = 1 },
          { name = "nvim_lua", keyword_length = 1 },
          { name = "buffer", keyword_length = 1 },
          { name = "luasnip", keyword_length = 1 },
        }),
        experimental = {
          ghost_text = true,
        },
        sorting = defaults.sorting,
      }
    end,
  },
}
