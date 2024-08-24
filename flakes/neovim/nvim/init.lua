local cmd = vim.cmd
local fn = vim.fn
local opt = vim.o
local g = vim.g

-- Enable true colour support
if fn.has('termguicolors') then
  opt.termguicolors = true
end

-- Search down into subfolders
opt.path = vim.o.path .. '**'

g.mapleader = ' '
g.maplocalleader = '\\'
g.autoformat = false
g.markdown_recommended_style = 0

opt.clipboard = "unnamedplus"
opt.cmdheight = 0
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.expandtab = true
opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
opt.ignorecase = true
opt.smartcase = true -- Don't ignore case with capitals
opt.number = true
opt.relativenumber = false
opt.cursorline = true
opt.lazyredraw = true
opt.showmatch = true -- Highlight matching parentheses, etc
opt.incsearch = true
opt.hlsearch = true
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.sidescrolloff = 3
opt.smartindent = true

opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.foldenable = false
opt.history = 2000
opt.undofile = true
opt.splitright = true
opt.splitbelow = true
opt.wrap = false

opt.jumpoptions = "stack"

vim.diagnostic.config({
  signs = false,
  virtual_text = false,
})

g.editorconfig = true

-- Native plugins
cmd.filetype('plugin', 'indent', 'on')
cmd.packadd('cfilter') -- Allows filtering the quickfix list with :cfdo

-- let sqlite.lua (which some plugins depend on) know where to find sqlite
vim.g.sqlite_clib_path = require('luv').os_getenv('LIBSQLITE')
