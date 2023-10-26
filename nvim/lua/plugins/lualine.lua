local M = {}
local icons = require("config.icons")

M.theme = function()
  local colors = {
    transparent = nil,
    black = "black",
    red = "red",
    green = "green",
    yellow = "yellow",
    blue = "blue",
    magenta = "magenta",
    cyan = "cyan",
    white = "white",
  }
  return {
    normal = {
      a = { fg = colors.black, bg = colors.blue, gui = "bold" },
      b = { fg = colors.white, bg = colors.transparent },
      c = { fg = colors.white, bg = colors.transparent },
    },
    visual = {
      a = { fg = colors.black, bg = colors.red, gui = "bold" },
      b = { fg = colors.white, bg = colors.red },
      c = { fg = colors.white, bg = colors.transparent },
    },
    replace = {
      a = { fg = colors.black, bg = colors.magenta, gui = "bold" },
      b = { fg = colors.white, bg = colors.black },
      c = { fg = colors.white, bg = colors.transparent },
    },
    insert = {
      a = { fg = colors.black, bg = colors.green, gui = "bold" },
      b = { fg = colors.white, bg = colors.black },
      c = { fg = colors.white, bg = colors.transparent },
    },
    command = {
      a = { fg = colors.black, bg = colors.yellow, gui = "bold" },
      b = { fg = colors.white, bg = colors.black },
      c = { fg = colors.white, bg = colors.transparent },
    },
    inactive = {
      a = { fg = colors.white, bg = colors.black, gui = "bold" },
      b = { fg = colors.white, bg = colors.black },
      c = { fg = colors.white, bg = colors.transparent },
    },
  }
end

return {
  "nvim-lualine/lualine.nvim",
  lazy = false,
  opts = function()
    local icons = require("lazyvim.config").icons
    local Util = require("lazyvim.util").ui

    return {
      options = {
        theme = M.theme(),
        component_separators = { left = ">", right = "<" },
        -- section_separators = { left = "", right = "" },
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha" } },
      },
      sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            "diagnostics",
            sections = { "error", "warn", "info", "hint" },
            symbols = {
              error = icons.diagnostics.Error,
              hint = icons.diagnostics.Hint,
              info = icons.diagnostics.Info,
              warn = icons.diagnostics.Warn,
            },
            colored = true,
            update_in_insert = false,
            always_visible = false,
          },
          {
            -- "filename",
            -- symbols = { modified = "  ", readonly = "", unnamed = "" },
          },
        },
        lualine_x = {
          -- stylua: ignore
          {
            function() return "  " .. require("dap").status() end,
            cond = function () return package.loaded["dap"] and require("dap").status() ~= "" end,
            color = Util.fg("Debug"),
          },
          { "branch" },
          {
            "diff",
            symbols = {
              added = icons.git.added,
              untracked = icons.git.added,
              removed = icons.git.deleted,
            },
            colored = true,
            always_visible = false,
          },
        },
        lualine_y = {},
        lualine_z = {},
      },
    }
  end,
}
