return {
  "is0n/fm-nvim",
  enabled = false,
  keys = {
    { "<leader>e", "<cmd>Xplr %:p<cr>", desc = "Xplr (cwd)" },
    { "<leader>E", "<cmd>Xplr<cr>", desc = "Xplr (root dir)" },
  },

  config = function(_, opts)
    require("fm-nvim").setup({
      -- Mappings used with the plugin
      ui = {
        -- Default UI (can be "split" or "float")
        default = "float",

        float = {
          -- Floating window border (see ':h nvim_open_win')
          border = "rounded",

          -- Highlight group for floating window/border (see ':h winhl')
          float_hl = "Normal",
          border_hl = "FloatBorder",

          -- Floating Window Transparency (see ':h winblend')
          blend = 0,

          -- Num from 0 - 1 for measurements
          height = 0.95,
          width = 0.95,

          -- X and Y Axis of Window
          x = 0.5,
          y = 0.5,
        },

        split = {
          -- Direction of split
          direction = "topleft",

          -- Size of split
          size = 24,
        },
      },

      mappings = {
        vert_split = "<C-v>",
        horz_split = "<C-h>",
        tabedit = "<C-t>",
        edit = "<C-e>",
      },
    })
  end,
}
