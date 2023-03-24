require('nvim_comment').setup({ create_mappings = false })
vim.keymap.set('n', '<leader>c', ':CommentToggle<CR>', { desc = 'Comment Toggle' })
vim.keymap.set('v', '<leader>c', ':CommentToggle<CR>', { desc = 'Comment Toggle' })
