return {

  -- Transparency works perfectly
  { "catppuccin/nvim" },
  { "Tsuzat/NeoSolarized.nvim" },
  { "shaunsingh/nord.nvim" },
  { "ellisonleao/gruvbox.nvim" },
  { "rose-pine/neovim" }, -- TINY TINY Telescope Pop in

  { "shaunsingh/oxocarbon.nvim" }, -- Telescope Popin
  { "rafamadriz/neon" }, --Bug: Code actions has background or border
  { "folke/tokyonight.nvim" }, -- Bug: doesn't wanna install??
  { "JoosepAlviste/palenightfall.nvim" }, -- Lazyvim has bg and Telescope Popin
  { "rebelot/kanagawa.nvim" }, -- Bug: Telescope border chunky
  { "Yagua/nebulous.nvim" }, -- Bug: Telescope highlight missing
  { "marko-cerovac/material.nvim" }, -- Bug: Telescope highlight missing

  -- Set default colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa",
    },
  },
}

--TODO: Find the following highlight groups and add them to transparent plugin

-- Telescope backgrounds
-- Code actions border
