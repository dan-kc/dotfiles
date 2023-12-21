return {
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                          flash                           │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        char = {
          enabled = false,
        },
      },
      highlight = {
        -- backdrop = false,
      },
      label = {
        -- allow uppercase labels
        uppercase = false,
        -- add any labels with the correct case here, that you want to exclude
        -- exclude = "qwfpbjluymgzxcdh",
      },
    },
    keys = {
      {
        "h",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
    },
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                         mini.ai                          │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
        },
      }
    end,
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                      mini.bracketed                      │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "echasnovski/mini.bracketed",
    event = "VeryLazy",
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                      mini.surround                       │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    opts = {
      mappings = {
        add = "sa", -- "surround add"
        delete = "sd",
        find = "sf",
        find_left = "sF",
        highlight = "sh",
        replace = "sr",
        update_n_lines = "sn",
      },
    },
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                      nvim-autopairs                      │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "windwp/nvim-autopairs",
    event = "VeryLazy",
    enabled = false,
    opts = {
      disable_filetype = { "TelescopePrompt" },
      disable_in_macro = true, -- disable when recording or executing a macro,
      disable_in_visualblock = false, -- disable when insert after visual block mode
      disable_in_replace_mode = true,
      -- ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
      enable_moveright = true,
      enable_afterquote = true, -- add bracket pairs after quote
      -- enable_check_bracket_line = true, --- check bracket in same line
      enable_check_bracket_line = false, --- check bracket in same line
      enable_bracket_in_quote = false, --
      enable_abbr = false, -- trigger abbreviation
      break_undo = true, -- switch for basic rule break undo sequence
      check_ts = true,
      map_cr = true,
      map_bs = true, -- map the <BS> key
      map_c_h = true, -- Map the <C-h> key to delete a pair
      map_c_w = false, -- map <c-w> to delete a pair if possible
    },
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                         LuaSnip                          │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "L3MON4D3/LuaSnip",
    event = "VeryLazy",
    config = function()
      local ls = require("luasnip")
      local extras = require("luasnip.extras")
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node
      local r = extras.rep
      -- local c = ls.choice_node
      ls.add_snippets("typescript", {
        s("clg", {
          t('console.log("'),
          i(1),
          t('", '),
          r(1),
          t(")"),
        }),
        s("clge", {
          t('console.log("'),
          i(1),
          t('");'),
        }),
      })

      vim.keymap.set({ "i", "s" }, "<C-a>", function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end)
      vim.keymap.set({ "i" }, "<C-z>", function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        end
      end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<C-c>", function()
        ls.jump(1)
      end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<C-x>", function()
        ls.jump(-1)
      end, { silent = true })
      return {
        history = true,
        update_events = "TextChanged,TextChangedI",
        delete_check_events = "TextChanged",
      }
    end,
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                         conform                          │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "stevearc/conform.nvim",
    -- enabled = false,
    event = "VeryLazy",
    opts = function()
      return {
        notify_on_error = false,
        format_on_save = {
          timeout_ms = 300,
          lsp_fallback = false, -- stops formatting when no formatters are listed in formatters_by_ft
        },
        formatters_by_ft = {
          -- typescript = { "prettier" },
          -- tsx = { "prettier" },
          -- javascript = { "prettier" },
          lua = { "stylua" },
          vue = { "prettier" },
          css = { "prettier" },
          scss = { "prettier" },
          less = { "prettier" },
          html = { "prettier" },
          json = { "prettier" },
          jsonc = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },
          graphql = { "prettier" },
          handlebars = { "prettier" },
          go = { "goimports" },
          c = { "clang_format" },
          proto = { "buf" },
        },
      }
    end,
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                          treesj                          │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "Wansmer/treesj",
    keys = {
      { "<Leader>j", "<cmd>TSJToggle<cr>", desc = "Join Toggle" },
    },
    opts = {
      use_default_keymaps = false,
      max_join_length = 400,
    },
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                          yanky                           │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "gbprod/yanky.nvim",
    dependencies = { { "kkharji/sqlite.lua", enabled = not jit.os:find("Windows") } },
    opts = {
      highlight = { timer = 250 },
      ring = { storage = jit.os:find("Windows") and "shada" or "sqlite" },
    },
    keys = {
        -- stylua: ignore
      { "<leader>p", function() require("telescope").extensions.yank_history.yank_history({ }) end, desc = "Open Yank History" },
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank text" },
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after cursor" },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before cursor" },
      { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after selection" },
      { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before selection" },
      { "[y", "<Plug>(YankyCycleForward)", desc = "Cycle forward through yank history" },
      { "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle backward through yank history" },
      { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
      { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
      { "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
      { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
      { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and indent right" },
      { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and indent left" },
      { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put before and indent right" },
      { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put before and indent left" },
      { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put after applying a filter" },
      { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put before applying a filter" },
    },
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                       portal.nvim                        │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "cbochs/portal.nvim",
    opts = function()
      return {
        labels = { "n", "e", "i" },
        window_options = {
          relative = "cursor",
          width = 80,
          height = 5,
          col = 2,
          focusable = false,
          border = "single",
          noautocmd = true,
        },
      }
    end,
    keys = {
      -- { "<C-,>", "<cmd>Portal jumplist backward<cr>", desc = "Portal back" },
      {
        "<C-/>",
        function()
          require("portal.builtin").jumplist.tunnel_backward({
            slots = {
              function(value)
                return value.buffer == vim.fn.bufnr()
              end,
            },
          })
        end,
        desc = "Portal back",
      },
      { "<C-.>", "<cmd>Portal jumplist forward<cr>", desc = "Portal forward" },
    },
  },

  -- {
  --   "cbochs/grapple.nvim",
  --   enabled = true,
  --   event = "VeryLazy",
  --   keys = {
  --     { "<leader>m", "<cmd>GrappleToggle<cr>", desc = "Grapple toggle tag" },
  --     { "<leader>k", "<cmd>GrapplePopup tags<cr>", desc = "Grapple popup tags" },
  --     { "<leader>", "<cmd>GrappleCycle forward<cr>", desc = "Grapple cycle forward" },
  --     { "<leader>J", "<cmd>GrappleCycle backward<cr>", desc = "Grapple cycle backward" },
  --   },
  -- },

  -- {
  --   "gbprod/substitute.nvim",
  --   enabled = false,
  --   keys = {
  --     { "r", "<cmd>lua require('substitute').operator()<cr>" },
  --     { "rr", "<cmd>lua require('substitute').line()<cr>" },
  --     { "R", "<cmd>lua require('substitute').eol()<cr>" },
  --     { "r", "<cmd>lua require('substitute').visual()<cr>", mode = "x" },
  --   },
  --   config = true,
  -- },
}
