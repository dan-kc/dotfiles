return {
  "nvim-neorg/neorg",
  build = ":Neorg sync-parsers",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>nn", "<cmd>Neorg workspace notes<cr>", desc = "Notes index" },
    { "<leader>nw", "<cmd>Neorg return<cr>", desc = "Return" },
  },
  config = function()
    require("neorg").setup({
      load = {
        ["core.defaults"] = {}, -- Loads default behaviour
        -- ["core.keybinds"] = {
        --   config = {
        -- hook = function(keybinds)
        --   -- Want to move one keybind into the other? `remap_key` moves the data of the
        --   -- first keybind to the second keybind, then unbinds the first keybind.
        --   keybinds.remap_key("norg", "n", "<backspace>", "<LocalLeader><backspace>")
        -- end,
        -- },
        -- },
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
