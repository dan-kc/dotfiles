return {

  {
    "folke/tokyonight.nvim",
    opts = { style = "moon" },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
  },
 -- Transparency works perfectly
  { "catppuccin/nvim" },
  { 
    "Tsuzat/NeoSolarized.nvim",  
    lazy = false,
    config = function()
      vim.cmd('colorscheme NeoSolarized')
    end
  },
  -- { "rrethy/nvim-base16" },
  { "dotsilas/darcubox-nvim" },
  { "shaunsingh/nord.nvim" },
  { "ellisonleao/gruvbox.nvim" },
  { "rose-pine/neovim" },
  { "shaunsingh/oxocarbon.nvim"},
  { "rebelot/kanagawa.nvim" },
  { "marko-cerovac/material.nvim" },
  { "JoosepAlviste/palenightfall.nvim" },
  { "folke/tokyonight.nvim" },
  { "projekt0n/github-nvim-theme" },
  -- Some transparency glitches
  { "rafamadriz/neon" }, --Bug: Code actions has background or border | Telescope symbols have background
  { "Yagua/nebulous.nvim" }, -- Bug: Gitsigns transparent popin
}
