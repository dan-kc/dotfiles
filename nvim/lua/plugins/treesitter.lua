return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    highlight = { enable = false },
    indent = { enable = false },
    ensure_installed = {
      "css",
      "go",
      "bash",
      "proto",
      "cpp",
      "tsx",
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-h>",
        node_incremental = "<C-h>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    },
  },
}
