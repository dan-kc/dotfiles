-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  use { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    requires = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      'j-hui/fidget.nvim',

      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',
    },
  }

  -- Harpoon
  use 'ThePrimeagen/harpoon'

  use { -- Autocompletion
    'hrsh7th/nvim-cmp',
    requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
  }

  -- Auto close brackets
  use 'rstacruz/vim-closer'

  -- Formatter
  -- use 'mhartington/formatter.nvim'
  use "lukas-reineke/lsp-format.nvim"

  -- Comment
  use "terrortylor/nvim-comment"

  use { -- File tree
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
    tag = 'nightly'                  -- optional, updated every week.
  }

  -- Improve startup time
  use 'lewis6991/impatient.nvim'

  use { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }

  -- Leap around buffer
  use 'ggandor/leap.nvim'

  use { -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  }

  -- Autopairs
  use "windwp/nvim-autopairs" -- Autopairs, integrates with both cmp and treesitter

  -- Git related plugins
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'lewis6991/gitsigns.nvim'
  use 'navarasu/onedark.nvim'               -- Theme inspired by Atom
  use 'nvim-lualine/lualine.nvim'           -- Fancier statusline
  use 'lukas-reineke/indent-blankline.nvim' -- Add indentation guides even on blank lines
  use 'tpope/vim-sleuth'                    -- Detect tabstop and shiftwidth automatically

  -- Terminal
  use { "akinsho/toggleterm.nvim", tag = '*', config = function()
    require("toggleterm").setup()
  end }

  -- Fuzzy Finder (files, lsp, etc)
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }

  -- Colorschemes
  use { "folke/tokyonight.nvim", commit = "8223c970677e4d88c9b6b6d81bda23daf11062bb" }
  use { "lunarvim/darkplus.nvim", commit = "2584cdeefc078351a79073322eb7f14d7fbb1835" }
  use { "NLKNguyen/papercolor-theme", commit = "9051480ad9129ff4ab4fffb38b44779b9081626f" }
  use { "ayu-theme/ayu-vim", commit = "0745635421688ce777f663d13531996cb4da6514" }
  use { "morhetz/gruvbox", commit = "bf2885a95efdad7bd5e4794dd0213917770d79b7" }
  use { "srcery-colors/srcery-vim", commit = "0ff514ff249d0e6b6cc4702d6606f196e3827fc8" }
  use { "4513ECHO/vim-colors-hatsunemiku", commit = "f3826fc3de5fbce1feb7c3f437a01d7b0cc9dd1e" }
  use { "ajmwagar/vim-deus", commit = "1be965e7bc1c01e7db5e46dcd0e50d32d4eef434" }

  -- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
  local has_plugins, plugins = pcall(require, 'custom.plugins')
  if has_plugins then
    plugins(use)
  end

  if is_bootstrap then
    require('packer').sync()
  end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | silent! LspStop | silent! LspStart | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})

require "general"
require "keymaps"
require "plugins.nvim_tree"
require "plugins.comment"
require "plugins.lualine"
require "plugins.indent_blankline"
require "plugins.gitsigns"
require "plugins.telescope"
require "plugins.treesitter"
require "lsp"
require "plugins.toggleterm"
require "plugins.impatient"
require "plugins.harpoon"
require "plugins.luasnip"
require "plugins.leap"

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
