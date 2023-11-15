return {
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                       mini.comment                       │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    dependecies = {
      { "nvim-treesitter/nvim-treesitter" },
    },
    opts = {
      options = {
        -- Doesn't work without this field. ts_context... enables tsx comments
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end,
      },
    },
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                       comment-box                        │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "LudoPinelli/comment-box.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>cb",
        function()
          require("comment-box").cbox()
        end,
        mode = { "n", "v" },
        noremap = true,
        silent = true,
        expr = false,
        desc = "Comment box center",
      },
    },
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                      todo-comments                       │
  --  ╰──────────────────────────────────────────────────────────╯
  -- Doesn't work atm, it fades after a second on load
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                          neogen                          │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "danymat/neogen",
    event = "VeryLazy",
    keys = {
      {
        "<leader>cc",
        function()
          require("neogen").generate({})
        end,
        desc = "Neogen Comment",
      },
    },
    opts = { snippet_engine = "luasnip" },
  },
}
