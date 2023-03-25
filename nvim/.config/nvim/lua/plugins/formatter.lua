local vim = vim
local formatter = require("formatter")

local prettierConfig = function()
  return {
    exe = "prettier",
    args = {
      "--stdin-filepath",
      vim.fn.shellescape(vim.api.nvim_buf_get_name(0)),
      "--single-quote",
      "--print-width" == 30
    },
    stdin = true
  }
end

local commonFT = {
  "css",
  "scss",
  "html",
  "java",
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "markdown",
  "markdown.mdx",
  "json",
  "yaml",
  "xml",
  "svg",
  "svelte"
}

local formatterConfig = {
  ['*'] = {
    require('formatter.filetypes.any').remove_trailing_whitespace
  }
}

for _, ft in ipairs(commonFT) do
  formatterConfig[ft] = { prettierConfig }
end
-- Setup functions
formatter.setup(
  {
    logging = false,
    filetype = formatterConfig,
  }
)
