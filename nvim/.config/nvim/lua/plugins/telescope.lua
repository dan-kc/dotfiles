local Util = require("lazyvim.util")
local actions = require("telescope.actions")

return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    config = function()
      require("telescope").load_extension("fzf")
    end,
  },
  opts = {
    defaults = {
      layout_strategy = "horizontal",
      layout_config = { prompt_position = "top" },
      sorting_strategy = "ascending",
      winblend = 0,
      mappings = {
        n = {
          ["zn"] = actions.send_selected_to_qflist + actions.open_qflist,
        },
      },
    },
  },
  keys = {
    { "<leader><space>", false },
    { "<leader>gc", false },
    { "<leader>sR", false },
    { "<leader>gs", false },
    { "<leader>fr", false },
    { "<leader>,", false },
    { "<leader>sw", false },
    { "<leader>sW", false },

    { "<leader>/", Util.telescope("oldfiles", { cwd = vim.loop.cwd() }), desc = "Recent (cwd)" },
    { "<leader>fF", Util.telescope("files"), desc = "Find Files (root dir)" },
    { "<leader>ff", Util.telescope("files", { cwd = false }), desc = "Find Files (cwd)" },
    { "<leader>'", "<cmd>Telescope resume<cr>", desc = "Resume" },
  },
}
