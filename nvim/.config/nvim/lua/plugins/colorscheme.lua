return {
  -- Install colorschemes
  { "ellisonleao/gruvbox.nvim" },
  { "catppuccin/nvim" },
  { "Tsuzat/NeoSolarized.nvim" },
  { "shaunsingh/oxocarbon.nvim" },
  { "rose-pine/neovim" },
  { "folke/tokyonight.nvim" },

  -- Set default colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
