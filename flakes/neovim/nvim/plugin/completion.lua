if vim.g.did_load_completion_plugin then
  return
end
vim.g.did_load_completion_plugin = true

local cmp = require('cmp')
local lspkind = require('lspkind')
local luasnip = require('luasnip')

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
local icons = require('user.icons')

local function has_words_before()
  local unpack_ = unpack or table.unpack
  local line, col = unpack_(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

---@param source string|table
local function complete_with_source(source)
  if type(source) == 'string' then
    cmp.complete { config = { sources = { { name = source } } } }
  elseif type(source) == 'table' then
    cmp.complete { config = { sources = { source } } }
  end
end

cmp.setup {
  completion = {
    completeopt = 'menu,menuone,preview,noinsert',
    autocomplete = false     -- disables automatic pop-up
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

  formatting = {
    format = lspkind.cmp_format {
      mode = "text_symbol", -- 'text', 'text_symbol', 'symbol_text', 'symbol'
      maxwidth = 80,
      ellipsis_char = "...",
      menu = {
        nvim_lsp = "[LSP]",
        path = "[PATH]",
        nvim_lua = "[LUA]",
        buffer = "[BUF]",
        nvim_lsp_signature_help = '[LSP]',
        nvim_lsp_document_symbol = '[LSP]',
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
    },
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-CR>"] = cmp.mapping.confirm(),
    -- ["<C-,>"] = function(fallback)
    --   if cmp.visible() then
    --     cmp.select_prev_item()
    --   else
    --     fallback()
    --   end
    -- end,
    -- ["<C-.>"] = function(fallback)
    --   if cmp.visible() then
    --     cmp.select_next_item()
    --   else
    --     fallback()
    --   end
    -- end,
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp",                keyword_length = 1 },
    { name = "path",                    keyword_length = 1 },
    { name = 'nvim_lsp_signature_help', keyword_length = 3 },
    { name = "nvim_lua",                keyword_length = 1 },
    { name = "buffer",                  keyword_length = 1 },
    { name = "luasnip",                 keyword_length = 1 },
  }),

  enabled = function()
    return vim.bo[0].buftype ~= 'prompt'
  end,
  experimental = {
    native_menu = false,
    ghost_text = true,
  },
}

vim.keymap.set('i', '<C-a>', function()
  cmp.complete()
end, { desc = 'Autocomplete' })

cmp.setup.filetype('lua', {
  sources = cmp.config.sources {
    { name = 'nvim_lua' },
    { name = 'nvim_lsp', keyword_length = 3 },
    { name = 'path' },
  },
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'nvim_lsp_document_symbol', keyword_length = 3 },
    { name = 'buffer' },
    { name = 'cmdline_history' },
  },
  view = {
    entries = { name = 'wildmenu', separator = '|' },
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources {
    { name = 'cmdline' },
    { name = 'cmdline_history' },
    { name = 'path' },
  },
})

vim.keymap.set({ 'i', 'c', 's' }, '<C-n>', cmp.complete, { noremap = false, desc = '[cmp] complete' })
vim.keymap.set({ 'i', 'c', 's' }, '<C-f>', function()
  complete_with_source('path')
end, { noremap = false, desc = '[cmp] path' })
vim.keymap.set({ 'i', 'c', 's' }, '<C-o>', function()
  complete_with_source('nvim_lsp')
end, { noremap = false, desc = '[cmp] lsp' })
vim.keymap.set({ 'c' }, '<C-h>', function()
  complete_with_source('cmdline_history')
end, { noremap = false, desc = '[cmp] cmdline history' })
vim.keymap.set({ 'c' }, '<C-c>', function()
  complete_with_source('cmdline')
end, { noremap = false, desc = '[cmp] cmdline' })
