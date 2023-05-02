-- Visit https://github.com/Tsuzat/NeoSolarized.nvim to learn the highlight groups for plugins
-- Also <leader>sH

return {
  "xiyaowong/transparent.nvim",
  enable = true,
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
    },
    extra_groups = {
      "NormalFloat", -- plugins which have float panel such as Lazy, Mason, LspInfo
      "NvimTreeNormal", -- NvimTree
      "NeoTreeExpander",
      "NeoTreeFileName",
      -- "lualine_c_normal",
      -- "lualine_transitional_lualine_b_normal_to_lualine_c_normal",
      -- "lualine_transitional_lualine_b_insert_to_lualine_c_normal",
      -- "lualine_transitional_lualine_b_visual_to_lualine_c_normal",
      -- "lualine_transitional_lualine_b_command_to_lualine_c_normal",
      "",

      -- "NeoTreeGitStaged",
      -- "NeoTreeModified",
      -- "NeoTreeGitUnstaged",
      -- "NeoTreeGitConflict",
    },
  },
}
