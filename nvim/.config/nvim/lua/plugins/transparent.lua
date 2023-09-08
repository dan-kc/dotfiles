-- Visit https://github.com/Tsuzat/NeoSolarized.nvim to learn the highlight groups for plugins
-- Also <leader>sH

return {
  "xiyaowong/transparent.nvim",
  enabled = true,
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
}
