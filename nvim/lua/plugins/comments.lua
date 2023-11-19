return {
  {
    "numToStr/Comment.nvim",
    lazy = false,
    opts = {
      toggler = { ---LHS of toggle mappings in NORMAL mode
        line = "gcc", ---Line-comment toggle keymap
        block = "gbc", ---Block-comment toggle keymap
      },
      opleader = { ---LHS of operator-pending mappings in NORMAL and VISUAL mode
        line = "gc", ---Line-comment keymap
        block = "gb", ---Block-comment keymap
      },
      extra = { ---LHS of extra mappings
        above = "gcO", ---Add comment on the line above
        below = "gco", ---Add comment on the line below
        eol = "gcA", ---Add comment at the end of line
      },
      mappings = {
        basic = true, ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
        extra = true, ---Extra mapping; `gco`, `gcO`, `gcA`
      },
      pre_hook = nil, ---Function to call before (un)comment
      post_hook = nil, ---Function to call after (un)comment
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
  -- TODO: fix?
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
