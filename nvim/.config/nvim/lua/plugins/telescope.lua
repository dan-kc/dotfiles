local Util = require("lazyvim.util")
return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    config = function()
      require("telescope").load_extension("fzf")
    end,
  },
  keys = {
    -- disable the keymap to grep files
    { "<leader><space>", false },
    { "<leader>fF", Util.telescope("files"), desc = "Find Files (root dir)" },
    { "<leader>ff", Util.telescope("files", { cwd = false }), desc = "Find Files (cwd)" },
    { "<leader>sR", false },
    { "<leader>sr", "<cmd>Telescope resume<cr>", desc = "Resume" },
  },
}
