return {
  -- Install colorschemes
  { "ellisonleao/gruvbox.nvim" }, -- Bug: Git highlight opaque background
  { "catppuccin/nvim" }, -- <3
  { "Tsuzat/NeoSolarized.nvim" },
  { "shaunsingh/oxocarbon.nvim" }, --Bug: Git highlight opaque background | Telescope looks kinda dead
  { "rose-pine/neovim" }, --Bug: Git highlight opaque background
  { "folke/tokyonight.nvim" }, -- Bug: doesn't wanna install??
  { "JoosepAlviste/palenightfall.nvim" }, -- Telescope opaque background
  { "rebelot/kanagawa.nvim" }, -- Bug: Telescope border chunky
  { "Yagua/nebulous.nvim" }, -- Bug: Telescope highlight missing
  { "marko-cerovac/material.nvim" }, -- Bug: Telescope highlight missing

  -- Set default colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
