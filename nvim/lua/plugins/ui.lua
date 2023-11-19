local icons = require("config.icons")
return {
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                     indent-blankline                     │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          "help",
          "lazy",
        },
      },
    },
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                     mini.indentscope                     │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "echasnovski/mini.indentscope",
    event = "VeryLazy",
    opts = {
      symbol = "│",
      options = { try_as_border = true },
    },
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                    nvim-web-devicons                     │
  --  ╰──────────────────────────────────────────────────────────╯
  { "nvim-tree/nvim-web-devicons", lazy = true },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                         barbecue                         │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    event = "VeryLazy",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      show_navic = false,
    },
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                         dressing                         │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    config = function()
      require("dressing").setup({
        input = { enabled = true, win_options = { winblend = 0, sidescrolloff = 7 } },
        select = { enabled = true },
      })
    end,
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                         gitsigns                         │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    -- enabled = false,
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
        -- add = { text = icons.git.add },
        -- change = { text = icons.git.mod },
        -- delete = { text = icons.git.remove },
        -- topdelete = { text = icons.git.remove },
        -- changedelete = { text = icons.git.remove },
        -- untracked = { text = icons.git.untracked },
      },
    },
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                         lualine                          │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = { "arkav/lualine-lsp-progress" },
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
              error = string.format("%s%s", icons.more.error, " "),
              warn = string.format("%s%s", icons.more.warningCircle, " "),
              info = string.format("%s%s", icons.more.info, " "),
            },
          },
        },
        lualine_x = {
          "lsp_progress",
        },
        lualine_y = { { "encoding" } },
        lualine_z = { { "branch", icon = icons.git.symbol } },
      },
    },
  },
}
