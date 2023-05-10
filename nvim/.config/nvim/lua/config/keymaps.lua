-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.del("n", "<leader>gg")
vim.keymap.del("n", "<leader>gG")
vim.keymap.del("n", "<leader>qq")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<leader>o", ":only<CR>", { desc = "Close all other panes" })
vim.keymap.set("n", "<leader>uL", ":set cursorline!<CR>", { desc = "Toggle cursor line" })

vim.keymap.set("n", "<leader>qo", ":copen<CR>", { desc = "Open" })
vim.keymap.set("n", "<leader>qn", ":cnext<CR>", { desc = "Next" })
vim.keymap.set("n", "<leader>qp", ":cprev<CR>", { desc = "Prev" })
