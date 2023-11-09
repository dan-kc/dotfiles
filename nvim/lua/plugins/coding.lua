return {
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                          flash                           │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    vscode = true,
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "'", mode = { "n", "x", "o" }, function() require("flash").jump({continue = true}) end,desc = "Resume last search" },
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
  --  │                       refactoring                        │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "ThePrimeagen/refactoring.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>n",
        function()
          require("refactoring").select_refactor()
        end,
        mode = "v",
        noremap = true,
        silent = true,
        expr = false,
        desc = "Refactor",
      },
    },
    opts = {},
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
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
      },
    },
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                      nvim-autopairs                      │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "windwp/nvim-autopairs",
    event = "VeryLazy",
    opts = {
      disable_filetype = { "TelescopePrompt" },
      disable_in_macro = true, -- disable when recording or executing a macro,
      disable_in_visualblock = false, -- disable when insert after visual block mode
      disable_in_replace_mode = true,
      ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
      enable_moveright = true,
      enable_afterquote = true, -- add bracket pairs after quote
      enable_check_bracket_line = true, --- check bracket in same line
      enable_bracket_in_quote = true, --
      enable_abbr = false, -- trigger abbreviation
      break_undo = true, -- switch for basic rule break undo sequence
      check_ts = true,
      map_cr = true,
      map_bs = false, -- map the <BS> key
      map_c_h = false, -- Map the <C-h> key to delete a pair
      map_c_w = false, -- map <c-w> to delete a pair if possible
    },
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                         LuaSnip                          │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "L3MON4D3/LuaSnip",
    event = "VeryLazy",
    -- stylua: ignore
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load({ paths = "~/.config/nvim/snippets" })
      local ls = require("luasnip")
    -- TODO: Fix error in ts files when using <c-z> twice
      vim.keymap.set({ "i" }, "<C-z>", function() ls.expand() end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<C-.>", function() ls.jump(1) end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<C-,>", function() ls.jump(-1) end, { silent = true })
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
}
