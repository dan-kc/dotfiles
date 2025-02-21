if vim.g.did_load_flash_plugin then
  return
end
vim.g.did_load_flash_plugin = true

require('flash').setup {
  label = {
    uppercase = false,
  },
}

-- First, set up a utility function to simplify the binding process
local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
end

-- Mapping for "flash jump"
map('n', '<leader><space>', function()
  require('flash').jump()
end, 'Flash')
map('x', '<leader><space>', function()
  require('flash').jump()
end, 'Flash')
map('o', '<leader><space>', function()
  require('flash').jump()
end, 'Flash')

-- Mapping for "flash treesitter"
map('n', 'H', function()
  require('flash').treesitter()
end, 'Flash Treesitter')
map('x', 'H', function()
  require('flash').treesitter()
end, 'Flash Treesitter')
map('o', 'H', function()
  require('flash').treesitter()
end, 'Flash Treesitter')

-- Mapping for "remote flash"
map('o', 'r', function()
  require('flash').remote()
end, 'Remote Flash')

-- Mapping for "treesitter search"
map('o', 'R', function()
  require('flash').treesitter_search()
end, 'Treesitter Search')
map('x', 'R', function()
  require('flash').treesitter_search()
end, 'Treesitter Search')
