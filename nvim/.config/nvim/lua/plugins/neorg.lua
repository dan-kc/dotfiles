return {
  "nvim-neorg/neorg",
  build = ":Neorg sync-parsers",
  dependencies = { "nvim-lua/plenary.nvim" },
  enabled = false,
  keys = {
    { "<leader>nn", "<cmd>Neorg workspace notes<cr>", desc = "Notes index" },
    { "<leader>nw", "<cmd>Neorg return<cr>", desc = "Return" },
  },
  config = function()
    require("neorg").setup({
      load = {
        ["core.defaults"] = {}, -- Loads default behaviour
        ["core.pivot"] = {}, -- Loads default behaviour
        ["core.concealer"] = {
          config = {
            icons = {
              todo = {
                uncertain = {
                  icon = "?",
                },
              },
            },
          },
        }, -- Adds pretty icons to your documents
        ["core.dirman"] = { -- Manages Neorg workspaces
          config = {
            workspaces = {
              notes = "~/notes",
            },
            default = "notes",
          },
        },
      },
    })
  end,
}
