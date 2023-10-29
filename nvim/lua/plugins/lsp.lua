return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
    event = "VeryLazy",
    opts = {
      diagnostics = {
        virtual_text = true,
      },
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")
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
        keys = {
          {
            "<leader>co",
            function()
              vim.lsp.buf.code_action({
                apply = true,
                context = {
                  only = { "source.organizeImports.ts" },
                  diagnostics = {},
                },
              })
            end,
            desc = "Organize Imports",
          },
          {
            "<leader>cR",
            function()
              vim.lsp.buf.code_action({
                apply = true,
                context = {
                  only = { "source.removeUnused.ts" },
                  diagnostics = {},
                },
              })
            end,
            desc = "Remove Unused Imports",
          },
        },
        settings = {
          typescript = {
            format = {
              indentSize = vim.o.shiftwidth,
              convertTabsToSpaces = vim.o.expandtab,
              tabSize = vim.o.tabstop,
            },
          },
          javascript = {
            format = {
              indentSize = vim.o.shiftwidth,
              convertTabsToSpaces = vim.o.expandtab,
              tabSize = vim.o.tabstop,
            },
          },
          completions = {
            completeFunctionCalls = true,
          },
        },
      })
      -- brew install rust_analyzer
      lspconfig.rust_analyzer.setup({})
      -- go install gopls
      lspconfig.gopls.setup({
        -- settings don't work
        settings = {
          gopls = {
            analyses = {
              unusedparams = false,
              unusedvariable = true,
            },
            staticcheck = true,
            gofumpt = true,
          },
        },
      })
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
      -- lspconfig.setup(opts)
    end,
  },
  {
    -- TODO: Fix nvim-lsp not loading initially
    "hrsh7th/nvim-cmp",
    event = "VeryLazy",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
    },
    keys = {
      {
        "<C-x>",
        mode = { "i" },
        function()
          require("cmp").complete()
        end,
        desc = "Autocomplete",
      },
    },
    opts = function()
      local cmp = require("cmp")
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      -- vim.keymap.set("i", "<C-x>", function()
      --   cmp.complete()
      -- end)
      local defaults = require("cmp.config.default")()
      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
          autocomplete = false,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<S-CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<C-CR>"] = function(fallback)
            cmp.abort()
            fallback()
          end,
        }),
        sources = cmp.config.sources({
          { name = "luasnip" },
          { name = "nvim_lsp" },
          { name = "path" },
          {
            { name = "buffer" }, -- Fallback to buffer if nothing from others
          },
        }),
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
        sorting = defaults.sorting,
      }
    end,
  },
}
