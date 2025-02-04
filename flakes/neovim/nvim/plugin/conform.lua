if vim.g.did_load_conform_plugin then
  return
end
vim.g.did_load_conform_plugin = true

require('conform').setup {
  formatters_by_ft = {
    -- Configured
    lua = { 'stylua' },
    nix = { 'nixfmt' },
    rust = { 'rustfmt' },
    go = { 'gofumpt' },
    terraform = { 'tfmt' },
    tf = { 'tfmt' },
    hcl = { 'tfmt' },
    python = { 'black' },

    typescript = { 'prettier' },
    tsx = { 'prettier' },
    jsx = { 'prettier' },
    javascript = { 'prettier' },
    vue = { 'prettier' },
    css = { 'prettier' },
    scss = { 'prettier' },
    less = { 'prettier' },
    html = { 'prettier' },
    json = { 'prettier' },
    jsonc = { 'prettier' },
    yaml = { 'prettier' },
    markdown = { 'prettier' },
    graphql = { 'prettier' },
    handlebars = { 'prettier' },
    toml = { 'taplo' },

    -- To be configured
    -- Go toml, docker,
    -- c = { 'clang_format' },
    -- proto = { 'buf' },
  },
  formatters = {
    tfmt = {
      command = 'tofu',
      args = { 'fmt', '-' },
      stdin = true,
    },
  },
}

opts = {
  async = true,
  lsp_fallback = false,
}

vim.keymap.set('n', '<leader>.', function()
  require('conform').format(opts)
end, { noremap = true, silent = true, desc = 'Format buffer' })
