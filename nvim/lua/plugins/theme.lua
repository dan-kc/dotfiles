return {
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                       nvim-base16                        │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "rrethy/nvim-base16",
    lazy = false,
    config = function()
      -- vim.cmd("colorscheme base16-rose-pine")
      -- vim.cmd("colorscheme base16-rose-pine-moon")
      -- vim.cmd("colorscheme base16-snazzy")
      vim.cmd("colorscheme base16-chalk")
      -- vim.cmd("colorscheme base16-circus")
      -- vim.cmd("colorscheme base16-solarflare")
      -- vim.cmd("colorscheme base16-qualia")
      -- vim.cmd("colorscheme base16-materia")
      -- vim.cmd("colorscheme base16-material-darker")
      -- vim.cmd("colorscheme base16-gigavolt")
      -- vim.cmd("colorscheme base16-darkmoss")
      -- vim.cmd("colorscheme base16-oceanicnext")
      -- vim.cmd("colorscheme base16-ashes")
      -- vim.cmd("colorscheme base16-framer")
      -- vim.cmd("colorscheme base16-monokai")
      -- vim.cmd("colorscheme base16-porple")
      -- vim.cmd("colorscheme base16-rebecca")
      -- vim.cmd("colorscheme base16-twilight")
      -- vim.cmd("colorscheme base16-black-metal")
      -- vim.cmd("colorscheme base16-brewer")
      -- vim.cmd("colorscheme base16-harmonic16-dark")
      -- vim.cmd("colorscheme base16-classic-dark")
      -- vim.cmd("colorscheme base16-danqing")
      -- vim.cmd("colorscheme base16-eighties")
      -- vim.cmd("colorscheme base16-gruvbox-dark-pale")
      -- vim.cmd("colorscheme base16-kimber")
    end,
  },
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                       transparent                        │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    dependencies = {
      "lewis6991/gitsigns.nvim",
    },
    opts = {
      groups = {
        -- "Must haves"
        "Normal",
        "NormalNC",
        "SignColumn",
        "LspPreviewBorder",
        "NormalFloat",
        "FloatBorder",

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

        -- Diagnostics
        "DiagnosticSignError",
        "DiagnosticSignWarn",
        "DiagnosticSignHint",
        "DiagnosticSignInfo",

        -- Barbecue
        "barbecue_normal",

        -- NeoTree
        "NeoTreeBufferNumber",
        "NeoTreeCursorLine",
        "NeoTreeDimText",
        "NeoTreeDirectoryIcon",
        "NeoTreeDirectoryName",
        "NeoTreeDotfile",
        "NeoTreeFadeText1",
        "NeoTreeFadeText2",
        "NeoTreeFileIcon",
        "NeoTreeFileName",
        "NeoTreeFileNameOpened",
        "NeoTreeFileStats",
        "NeoTreeFileStatsHeader",
        "NeoTreeFilterTerm",
        "NeoTreeFloatBorder",
        "NeoTreeFloatNormal",
        "NeoTreeFloatTitle",
        "NeoTreeGitAdded",
        "NeoTreeGitConflict",
        "NeoTreeGitDeleted",
        "NeoTreeGitIgnored",
        "NeoTreeGitModified",
        "NeoTreeGitRenamed",
        "NeoTreeGitStaged",
        "NeoTreeGitUntracked",
        "NeoTreeGitUnstaged",
        "NeoTreeHiddenByName",
        "NeoTreeIndentMarker",
        "NeoTreeMessage",
        "NeoTreeModified",
        "NeoTreeNormal",
        "NeoTreeNormalNC",
        "NeoTreeSignColumn",
        "NeoTreeStatusLine",
        "NeoTreeStatusLineNC",
        "NeoTreeTabActive",
        "NeoTreeTabInactive",
        "NeoTreeTabSeparatorActive",
        "NeoTreeTabSeparatorInactive",
        "NeoTreeVertSplit",
        "NeoTreeWinSeparator",
        "NeoTreeEndOfBuffer",
        "NeoTreeRootName",
        "NeoTreeSymbolicLinkTarget",
        "NeoTreeTitleBar",
        "NeoTreeIndentMarker",
        "NeoTreeExpander",
        "NeoTreeWindowsHidden",
        "NeoTreePreview",

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
