return {
  "code-biscuits/nvim-biscuits",
  enabled = false,
  dependencies = {
    { "nvim-treesitter/nvim-treesitter" },
  },
  opts = {
    cursor_line_only = true,
    default_config = {
      min_distance = 4,
    },
  },
}
