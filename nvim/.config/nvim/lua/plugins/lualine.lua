-- Set lualine as statusline
-- See `:help lualine.txt`
require('lualine').setup {
  options = {
    component_separators = '|',
    section_separators = '',
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'filename' },
      lualine_c = { 'branch', 'diff', 'diagnostics' },
      lualine_x = { 'encoding', 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' }
    },
  },
}
