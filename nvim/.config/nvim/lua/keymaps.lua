-- Set <space> as the leader key
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '<C-p>', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<C-n>', vim.diagnostic.goto_next)
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- Format
vim.keymap.set('n', '<leader>p', vim.cmd.Format)

-- Move highlighted text
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

-- Keep cursor position with J
vim.keymap.set("n", "J", "mzJ`z")

-- Keep cursor in middle
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Remove "INSERT"
vim.opt.showmode = false

-- System clipboard
vim.opt.clipboard = "unnamedplus"

-- Encoding
vim.opt.fileencoding = "utf-8"

-- Smartcase
vim.opt.smartcase = true

-- force split location
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Persistent undo
vim.opt.undofile = true

-- Update time
vim.opt.updatetime = 300

-- Don't wrap
vim.opt.wrap = false

-- Only
vim.keymap.set("n", "<leader>o", ":only<CR>")

-- V split
vim.keymap.set("n", "<leader>v", ":vsplit<CR>")

-- Toggle split
vim.keymap.set("n", "<leader><Tab>", "<C-w>w")

-- Replace
vim.keymap.set("n", "<leader>r", ":%s/")
