return {
  {
    "rrethy/nvim-base16",
    lazy = false,
    config = function()
      vim.cmd("colorscheme base16-ashes")
    end,
  },
  -- {
  --   "folke/tokyonight.nvim",
  --   opts = { style = "moon" },
  -- },
  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  -- },
  -- -- Transparency works perfectly
  -- { "catppuccin/nvim" },
  -- {
  --   "Tsuzat/NeoSolarized.nvim",
  -- },
  -- { "dotsilas/darcubox-nvim" },
  -- { "shaunsingh/nord.nvim" },
  -- {
  --   "ellisonleao/gruvbox.nvim",
  -- },
  -- { "rose-pine/neovim" },
  -- { "shaunsingh/oxocarbon.nvim" },
  -- { "rebelot/kanagawa.nvim" },
  -- { "marko-cerovac/material.nvim" },
  -- { "JoosepAlviste/palenightfall.nvim" },
  -- { "folke/tokyonight.nvim" },
  -- { "projekt0n/github-nvim-theme" },
  -- -- Some transparency glitches
  -- { "rafamadriz/neon" }, --Bug: Code actions has background or border | Telescope symbols have background
  -- { "Yagua/nebulous.nvim" }, -- Bug: Gitsigns transparent popin
  -- -- Visit https://github.com/Tsuzat/NeoSolarized.nvim to learn the highlight groups for plugins
  -- -- Also <leader>sH

  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    dependencies = {
      -- "nvim-telescope/telescope.nvim",
      "lewis6991/gitsigns.nvim",
    },
    opts = {
      groups = {
        -- "Must haves"
        "Normal",
        "NormalNC",
        "SignColumn",

        "VertSplit",
        "StatusLine",
        "Comment",
        "Constant",
        "Special",
        "Identifier",
        "Statement",
        "PreProc",
        "Type",
        "Title",
        "Underlined",
        "Todo",
        "String",
        "Function",
        "FloatTitle",
        "FloatShadow",
        "FloatShadowThrough",
        "Conditional",
        "Repeat",
        "Operator",
        "Structure",
        "LineNr",
        "NonText",
        "CursorLineNr",
        "EndOfBuffer",
        "MsgSeparator",
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

        -- Lualine
        "lualine_b_insert",
        "lualine_b_normal",
        "lualine_b_replace",
        "lualine_b_command",
        "lualine_b_terminal",
        "lualine_b_inactive",
        "lualine_b_visual",
        "lualine_c_insert",
        "lualine_c_normal",
        "lualine_c_replace",
        "lualine_c_command",
        "lualine_c_terminal",
        "lualine_c_inactive",
        "lualine_c_visual",
        "lualine_c_diagnostics_warn_insert",
        "lualine_c_diagnostics_warn_normal",
        "lualine_c_diagnostics_warn_replace",
        "lualine_c_diagnostics_warn_command",
        "lualine_c_diagnostics_warn_terminal",
        "lualine_c_diagnostics_warn_inactive",
        "lualine_c_diagnostics_warn_visual",
        "lualine_c_diagnostics_info_insert",
        "lualine_c_diagnostics_info_normal",
        "lualine_c_diagnostics_info_replace",
        "lualine_c_diagnostics_info_command",
        "lualine_c_diagnostics_info_terminal",
        "lualine_c_diagnostics_info_inactive",
        "lualine_c_diagnostics_info_visual",
        "lualine_c_diagnostics_error_insert",
        "lualine_c_diagnostics_error_normal",
        "lualine_c_diagnostics_error_replace",
        "lualine_c_diagnostics_error_command",
        "lualine_c_diagnostics_error_terminal",
        "lualine_c_diagnostics_error_inactive",
        "lualine_c_diagnostics_error_visual",
        "lualine_c_diagnostics_hint_insert",
        "lualine_c_diagnostics_hint_normal",
        "lualine_c_diagnostics_hint_replace",
        "lualine_c_diagnostics_hint_command",
        "lualine_c_diagnostics_hint_terminal",
        "lualine_c_diagnostics_hint_inactive",
        "lualine_c_diagnostics_hint_visual",
      },
    },
  },
}
