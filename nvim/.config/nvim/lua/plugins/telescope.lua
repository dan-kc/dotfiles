local Util = require("lazyvim.util")
local actions = require("telescope.actions")

return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    -- {
    --   "nvim-telescope/telescope-smart-history.nvim",
    --   config = function()
    --     require("telescope").load_extension("smart_history")
    --   end,
    --   dependencies = "kkharji/sqlite.lua",
    -- },
    {
      "nvim-telescope/telescope-file-browser.nvim",
      -- opts = {
      --   hide_parent_dir = true,
      --   -- hidden = { file_browser = false, folder_browser = false },
      -- },

      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
    },
  },
  opts = {
    defaults = {
      layout_strategy = "horizontal",
      layout_config = { prompt_position = "bottom" },
      sorting_strategy = "ascending",
      winblend = 0,
      mappings = {
        n = {
          ["zn"] = actions.send_selected_to_qflist + actions.open_qflist,
        },
      },
    },
    extensions = {
      file_browser = {
        -- cwd_to_path = false,
        -- grouped = false,
        -- files = true,
        -- add_dirs = true,
        -- depth = 2,
        -- auto_depth = false,
        -- select_buffer = false,
        hidden = { file_browser = true, folder_browser = true },
        hide_parent_dir = true,
        -- collapse_dirs = false,
        -- prompt_path = false,
        -- quiet = false,
        -- dir_icon = "",
        -- dir_icon_hl = "Default",
        -- display_stat = { date = false, size = false, mode = true },
        -- hijack_netrw = false,
        use_fd = true,
        git_status = true,
        -- mappings = {
        --   ["i"] = {
        --     ["<A-c>"] = fb_actions.create,
        --     ["<S-CR>"] = fb_actions.create_from_prompt,
        --     ["<A-r>"] = fb_actions.rename,
        --     ["<A-m>"] = fb_actions.move,
        --     ["<A-y>"] = fb_actions.copy,
        --     ["<A-d>"] = fb_actions.remove,
        --     ["<C-o>"] = fb_actions.open,
        --     ["<C-g>"] = fb_actions.goto_parent_dir,
        --     ["<C-e>"] = fb_actions.goto_home_dir,
        --     ["<C-w>"] = fb_actions.goto_cwd,
        --     ["<C-t>"] = fb_actions.change_cwd,
        --     ["<C-f>"] = fb_actions.toggle_browser,
        --     ["<C-h>"] = fb_actions.toggle_hidden,
        --     ["<C-s>"] = fb_actions.toggle_all,
        --     ["<bs>"] = fb_actions.backspace,
        --   },
        --   ["n"] = {
        --     ["c"] = fb_actions.create,
        --     ["r"] = fb_actions.rename,
        --     ["m"] = fb_actions.move,
        --     ["y"] = fb_actions.copy,
        --     ["d"] = fb_actions.remove,
        --     ["o"] = fb_actions.open,
        --     ["g"] = fb_actions.goto_parent_dir,
        --     ["e"] = fb_actions.goto_home_dir,
        --     ["w"] = fb_actions.goto_cwd,
        --     ["t"] = fb_actions.change_cwd,
        --     ["f"] = fb_actions.toggle_browser,
        --     ["h"] = fb_actions.toggle_hidden,
        --     ["s"] = fb_actions.toggle_all,
        --   },
        -- },
      },
    },
  },
  keys = {
    { "<leader><space>", false },
    -- { "<leader><sc>", false },
    { "<leader>gc", false },
    { "<leader>sR", false },
    { "<leader>fR", false },
    { "<leader>gs", false },
    { "<leader>fr", false },
    { "<leader>,", false },
    { "<leader>sw", false },
    { "<leader>sW", false },
    { "<leader>E", "<cmd>Telescope file_browser<CR>", desc = "File browser" },
    { "<leader>e", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>", desc = "File browser" },
    { "<leader>/", Util.telescope("oldfiles", { cwd = vim.loop.cwd() }), desc = "Recent (cwd)" },
    { "<leader>fF", Util.telescope("files"), desc = "Find Files (root dir)" },
    { "<leader>ff", Util.telescope("files", { cwd = false }), desc = "Find Files (cwd)" },
    { "<leader>'", "<cmd>Telescope resume<cr>", desc = "Resume" },
  },
  config = function(_, opts)
    require("telescope").setup(opts)
    require("telescope").load_extension("file_browser")
    require("telescope").load_extension("fzf")
  end,
}
