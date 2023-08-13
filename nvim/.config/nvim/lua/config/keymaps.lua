-- Tabs
vim.keymap.del("n", "<leader><tab>l")
vim.keymap.del("n", "<leader><tab>f")
vim.keymap.del("n", "<leader><tab><tab>")
vim.keymap.del("n", "<leader><tab>]")
vim.keymap.del("n", "<leader><tab>d")
vim.keymap.del("n", "<leader><tab>[")

-- Terminal
vim.keymap.del("n", "<leader>ft")
vim.keymap.del("n", "<leader>fT")
vim.keymap.del("n", "<c-/>")
vim.keymap.del("n", "<c-_>")

-- Lazygit
vim.keymap.del("n", "<leader>gg")
vim.keymap.del("n", "<leader>gG")

vim.keymap.del("n", "<leader>qq") -- Quit all
vim.keymap.del("n", "<leader>fn") -- New file

-- Move lines
vim.keymap.del("n", "<A-j>")
vim.keymap.del("n", "<A-k>")
vim.keymap.del("i", "<A-j>")
vim.keymap.del("i", "<A-k>")
vim.keymap.del("v", "<A-j>")
vim.keymap.del("v", "<A-k>")

-- Move to window
vim.keymap.del("n", "<C-h>")
vim.keymap.del("n", "<C-j>")
vim.keymap.del("n", "<C-k>")
vim.keymap.del("n", "<C-l>")
vim.keymap.del("n", "<leader>ww")

-- Resize window
vim.keymap.del("n", "<C-Up>")
vim.keymap.del("n", "<C-Down>")
vim.keymap.del("n", "<C-Left>")
vim.keymap.del("n", "<C-Right>")

-- Split window
-- vim.keymap.del("n", "<leader>w|")
-- vim.keymap.del("n", "<leader>w-")

-- Delete window
-- vim.keymap.del("n", "<leader>wd")

-- Center screen on jump
-- vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Buffer
-- vim.keymap.set("n", "<leader>wo", ":only<CR>", { desc = "Close all other windows" })
-- vim.keymap.del("n", "<leader>bb")

vim.keymap.set("n", "<leader>wo", ":only<CR>", { desc = "Close all other windows" })
vim.keymap.set("n", "<leader>wx", "<C-w>x", { desc = "Swap window with next" })
vim.keymap.set("n", "<leader>uL", ":set cursorline!<CR>", { desc = "Toggle cursor line" })
vim.keymap.set("n", "<leader>qo", ":copen<CR>", { desc = "Open list" })
vim.keymap.set("n", "<leader>qn", ":cnext<CR>", { desc = "Next item" })
vim.keymap.set("n", "<leader>qp", ":cprev<CR>", { desc = "Prev item" })

-- -- Resize window
-- vim.keymap.set("n", "<S-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
-- vim.keymap.set("n", "<S-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
-- vim.keymap.set("n", "<S-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
-- vim.keymap.set("n", "<S-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- vim.keymap.set("n", "<leader><tab>", "<C-W>p", { desc = "Other window", remap = true })
