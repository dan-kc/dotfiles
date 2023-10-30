local icons = require("config.icons")
return {
  "nvim-lualine/lualine.nvim",
  lazy = false,
  opts = {
    options = {
      theme = "auto",
      component_separators = "",
      section_separators = "",
    },
    sections = {
      lualine_a = { { "mode" } },
      lualine_b = { { "location", "progress" } },
      lualine_c = {
        {
          "diagnostics",
          sections = { "error", "warn", "info", "hint" },
          sources = { "nvim_diagnostic" },
          symbols = {
            error = string.format("%s%s", icons.diagnostics.Error, " "),
            warn = string.format("%s%s", icons.diagnostics.Warning, " "),
            info = string.format("%s%s", icons.diagnostics.Information, " "),
          },
        },
      },
      lualine_x = {},
      lualine_y = { { "encoding" } },
      lualine_z = { { "branch", icon = icons.git.Branch } },
    },
  },
}
