return {
  -- Install colorschemes
  { "ellisonleao/gruvbox.nvim" },
  { "catppuccin/nvim" },
  { "shaunsingh/oxocarbon.nvim" },
  { "rose-pine/neovim", name = "rose-pine" },

  -- Set default colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-frappe",
    },
  },
}
