return {
  "neovim/nvim-lspconfig",
  event = "VeryLazy",
  config = function()
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
    lspconfig.gopls.setup({})
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
      --- ...
      on_attach = function(_, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          command = "EslintFixAll",
        })
      end,
    })
  end,
  opts = {
    diagnostics = {
      virtual_text = true,
    },
  },
}
