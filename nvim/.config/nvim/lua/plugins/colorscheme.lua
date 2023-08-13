return {

  -- Transparency works perfectly
  { "catppuccin/nvim" },
  { "Tsuzat/NeoSolarized.nvim" },
  { "shaunsingh/nord.nvim" },
  { "ellisonleao/gruvbox.nvim" },
  { "rose-pine/neovim" },
  { "shaunsingh/oxocarbon.nvim" },
  { "rebelot/kanagawa.nvim" },
  { "marko-cerovac/material.nvim" },
  { "JoosepAlviste/palenightfall.nvim" },
  { "folke/tokyonight.nvim" },

  -- Some transparency glitches
  { "rafamadriz/neon" }, --Bug: Code actions has background or border | Telescope symbols have background
  { "Yagua/nebulous.nvim" }, -- Bug: Gitsigns transparent popin

  -- Set default colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
}

--TODO: Find the following highlight groups and add them to transparent plugin

-- Telescope backgrounds
-- Code actions border
