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
  },
  { "rrethy/nvim-base16" },
  { "dotsilas/darcubox-nvim" },
  { "shaunsingh/nord.nvim" },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    config = function()
      vim.cmd("colorscheme gruvbox")
    end,
  },
  { "rose-pine/neovim" },
  { "shaunsingh/oxocarbon.nvim" },
  { "rebelot/kanagawa.nvim" },
  { "marko-cerovac/material.nvim" },
  { "JoosepAlviste/palenightfall.nvim" },
  { "folke/tokyonight.nvim" },
  { "projekt0n/github-nvim-theme" },
  -- Some transparency glitches
  { "rafamadriz/neon" }, --Bug: Code actions has background or border | Telescope symbols have background
  { "Yagua/nebulous.nvim" }, -- Bug: Gitsigns transparent popin
  -- Visit https://github.com/Tsuzat/NeoSolarized.nvim to learn the highlight groups for plugins
  -- Also <leader>sH

  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "lewis6991/gitsigns.nvim",
    },
    opts = {
      groups = {
        -- "Must haves"
        "Normal",
        "NormalNC",
        "SignColumn",

        -- "VertSplit",
        -- "StatusLine",
        -- "Comment",
        -- "Constant",
        -- "Special",
        -- "Identifier",
        -- "Statement",
        -- "PreProc",
        -- "Type",
        -- "Title",
        -- "Underlined",
        -- "Todo",
        -- "String",
        -- "Function",
        -- "FloatTitle",
        -- "FloatShadow",
        -- "FloatShadowThrough",
        -- "Conditional",
        -- "Repeat",
        -- "Operator",
        -- "Structure",
        -- "LineNr",
        -- "NonText",
        -- "CursorLineNr",
        -- "EndOfBuffer",
        -- "MsgSeparator",
      },
      extra_groups = {

        -- Plugins which have float panel such as Lazy, Mason, LspInfo
        -- "NormalFloat",
        -- "FloatBorder",

        -- Telescope
        -- "TelescopeNormal",
        -- "TelescopeMatching",
        -- "TelescopeSelection",
        -- "TelescopePromptNormal",
        -- -- "TelescopePromptBorder",
        -- "TelescopePromptTitle",
        -- "TelescopePromptPrefix",
        -- -- "TelescopeResultsBorder",
        -- "TelescopeResultsNormal",
        -- "TelescopeResultsTitle",
        -- -- "TelescopePreviewBorder",
        -- "TelescopePreviewNormal",
        -- "TelescopePreviewTitle",
        -- "TelescopeResultsDiffChange",
        -- "TelescopeResultsDiffAdd",
        -- "TelescopeResultsDiffDelete",
        -- "TelescopeSelectionCaret",

        -- GitSigns
        "GitSignsChange",
        "GitSignsAdd",
        "GitSignsDelete",
        "GitSignsAddLine",

        -- Which key
        -- "WhichKeyFloat",
        -- "WhichKeyBorder",

        -- Diagnostics
        "DiagnosticSignError",
        "DiagnosticSignWarn",
        "DiagnosticSignHint",
        "DiagnosticSignInfo",

        -- Barbecue
        "barbecue_normal",

        -- Neotree
        -- "NeoTreeNormal",

        -- Bqf
        -- "BqfPreviewFloat", -- Doesn't work?
        -- "BqfPreviewBorder",
        -- "BqfPreviewTitle",
        -- "BqfPreviewThumb",
        -- "BqfPreviewSbar",
        -- "BqfPreviewCursor",
        -- "BqfPreviewCursorLine",
        -- "BqfPreviewRange",
        -- "BqfPreviewBufLabel",

        -- Noice
        -- "NoicePopupmenu",
        -- "NoiceScrollbar",
        -- "NoiceFormatConfirm",
        -- "NoiceScrollbarThumb",
      },
    },
  },
}
