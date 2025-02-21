if vim.g.did_load_dropbar_plugin then
  return
end
vim.g.did_load_dropbar_plugin = true

require('dropbar').setup {}

local dropbar_api = require('dropbar.api')

vim.keymap.set('n', '<Leader>;', dropbar_api.pick, { desc = 'Pick symbols in winbar' })
vim.keymap.set('n', '[;', dropbar_api.goto_context_start, { desc = 'Go to start of current context' })
vim.keymap.set('n', '];', dropbar_api.select_next_context, { desc = 'Select next context' })
