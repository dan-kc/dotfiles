local icons = require("config.icons")
return {
  "nvim-lualine/lualine.nvim",
  lazy = false,
  -- dependencies = {
  --   "xiyaowong/transparent.nvim",
  -- },
  opts = {
    options = {
      -- Disable sections and component separators
      theme = "auto",
      component_separators = "",
      section_separators = "",
    },
    sections = {
      -- these are to remove the defaults
      lualine_a = { { "mode" } },
      lualine_b = { { "location", "progress" } },
      lualine_c = {
        {
          "diagnostics",
          sections = { "error", "warn", "info", "hint" },
          sources = { "nvim_diagnostic" },
          symbols = {
            error = icons.diagnostics.Error,
            warn = icons.diagnostics.Warning,
            info = icons.diagnostics.Information,
          },
        },
      },
      lualine_x = {
        -- {
        --   "diff",
        --   symbols = {
        --     added = icons.git.LineAdded,
        --     modified = icons.git.LineModified,
        --     removed = icons.git.LineRemoved,
        --   },
        -- },
      },
      lualine_y = { { "encoding" } },
      lualine_z = { { "branch", icon = icons.git.Branch } },
    },
  },
}
