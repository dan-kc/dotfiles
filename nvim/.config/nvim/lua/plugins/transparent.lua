-- Visit https://github.com/Tsuzat/NeoSolarized.nvim to learn the highlight groups for plugins
-- Also <leader>sH

return {
  "xiyaowong/transparent.nvim",
  enable = true,
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "lewis6991/gitsigns.nvim",
  },
  opts = {
    groups = { -- table: default groups
      "Normal",
      "NormalNC",
      "Comment",
      "Constant",
      "Special",
      "Identifier",
      "Statement",
      "PreProc",
      "Type",
      "Underlined",
      "Todo",
      "String",
      "Function",
      "Conditional",
      "Repeat",
      "Operator",
      "Structure",
      "LineNr",
      "NonText",
      "SignColumn",
      "CursorLineNr",
      "EndOfBuffer",
      "StatusLine",
      "MsgSeparator",
    },
    extra_groups = {

      -- Plugins which have float panel such as Lazy, Mason, LspInfo
      "NormalFloat",
      "FloatBorder",

      -- Telescope
      "TelescopeNormal",
      "TelescopeMatching",
      "TelescopeSelection",
      "TelescopePromptNormal",
      "TelescopePromptBorder",
      "TelescopePromptTitle",
      "TelescopePromptPrefix",
      "TelescopeResultsBorder",
      "TelescopeResultsNormal",
      "TelescopeResultsTitle",
      "TelescopePreviewBorder",
      "TelescopePreviewNormal",
      "TelescopePreviewTitle",
      "TelescopeResultsDiffChange",
      "TelescopeResultsDiffAdd",
      "TelescopeResultsDiffDelete",
      "TelescopeSelectionCaret",

      -- GitSigns
      "GitSignsChange",
      "GitSignsAdd",
      "GitSignsDelete",

      -- Which key
      "WhichKeyFloat",
      "WhichKeyBorder",

      -- Diagnostics
      "DiagnosticSignError",
      "DiagnosticSignWarn",
      "DiagnosticSignHint",
      "DiagnosticSignInfo",
    },
  },
}
