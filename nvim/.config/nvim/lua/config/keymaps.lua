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

vim.keymap.set(
  "i",
  "<c-c>b",
  "<cmd>lua vim.g.cmp_toggle = false ; vim.g.codeium_enabled = false <CR>",
  { desc = "Disable both cmp and codeium" }
)
vim.keymap.set(
  "i",
  "<c-c>a",
  "<cmd>lua vim.g.codeium_enabled = false ; vim.g.cmp_toggle = true <CR>",
  { desc = "Enable cmp" }
)
vim.keymap.set(
  "i",
  "<c-c>A",
  "<cmd>lua vim.g.cmp_toggle = false ; vim.g.codeium_enabled = true <CR>",
  { desc = "Enable codeium" }
)
