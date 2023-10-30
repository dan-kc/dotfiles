return {
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

  {
    "echasnovski/mini.indentscope",
    event = "VeryLazy",
    opts = {
      symbol = "│",
      options = { try_as_border = true },
    },
  },

  { "nvim-tree/nvim-web-devicons", lazy = true },

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

  {
    "code-biscuits/nvim-biscuits",
    enabled = false,
    event = "VeryLazy",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter" },
    },
    opts = {
      cursor_line_only = true,
      default_config = {
        min_distance = 1,
      },
    },
  },
}
