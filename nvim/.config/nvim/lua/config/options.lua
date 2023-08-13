local opt = vim.opt

-- opt.number = false -- Print line number
-- opt.relativenumber = false
opt.cursorline = false
opt.undofile = true

-- Reduce command buffer size
opt.cmdwinheight = 1

-- Folding (nvim-ufo)
opt.foldcolumn = "0"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
opt.timeoutlen = 1000

-- Jumplist (portal.nvim)
opt.jumpoptions = "stack"

-- Disable comment continuation (doesn't work)
opt.formatoptions:remove("o") -- Don't continue after 'o' or 'O'
opt.formatoptions:remove("r") -- Don't continue after <cr>
