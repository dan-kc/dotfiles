if vim.g.did_load_lspconfig_plugin then
  return
end
vim.g.did_load_lspconfig_plugin = true

local icons = require('user.icons')
local lspconfig = require('lspconfig')

-- Defaults are not working for some reason.
lspconfig.util.default_config = vim.tbl_extend(
  "force",
  lspconfig.util.default_config,
  {
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
    inlay_hints = {
      enabled = false,
    },
    format = {
      formatting_options = nil,
      timeout_ms = nil,
    },
  }
)

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

-- lspconfig.nil_ls.setup({})

lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
    },
    diagnostics = {
      -- Get the language server to recognize the `vim` global, etc.
      globals = {
        'vim',
        'describe',
        'it',
        'assert',
        'stub',
      },
      disable = {
        'duplicate-set-field',
      },
    },
    workspace = {
      checkThirdParty = false,
    },
    telemetry = {
      enable = false,
    },
  },
})

-- lspconfig.shopify_theme_ls.setup({})

-- lspconfig.elixirls.setup({
--   cmd = { "/opt/homebrew/bin/elixir-ls" },
-- })

lspconfig.ts_ls.setup({
  settings = {
    filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
  },
})

lspconfig.rust_analyzer.setup({})

lspconfig.gopls.setup({})

-- require("lspconfig").jsonls.setup({
--   settings = {
--     json = {
--       schemas = require("schemastore").json.schemas(),
--       validate = { enable = true },
--     },
--   },
-- })

-- lspconfig.tailwindcss.setup({
--   settings = {
--     tailwindcss = {
--       filetypes_exclude = { "markdown" },
--     },
--   },
-- })

-- lspconfig.pyright.setup({})

-- lspconfig.yamlls.setup({
--   settings = {
--     yaml = {
--       keyOrdering = false,
--     },
--     schemaStore = {
--       enable = false,
--       url = "",
--     },
--     schemas = require("schemastore").yaml.schemas(),
--   },
-- })

-- lspconfig.marksman.setup({})

-- lspconfig.eslint.setup({
--   on_attach = function(_, bufnr)
--     vim.api.nvim_create_autocmd("BufWritePre", {
--       buffer = bufnr,
--       command = "EslintFixAll",
--     })
--   end,
-- })

-- go install github.com/bufbuild/buf-language-server/cmd/bufls@latest
-- lspconfig.buf_ls.setup({})
