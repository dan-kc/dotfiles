return {
  "cbochs/portal.nvim",
  enabled = false,
  -- Optional dependencies
  opts = {
    labels = { "n", "e", "i", "o", "l", "u", "y", "'" },
    wrap = true,
    window_options = {
      relative = "cursor",
      width = 80,
      height = 6,
      col = 4,
      focusable = false,
      border = "single",
      noautocmd = true,
    },
  },
  keys = {
    { "<leader>o", "<cmd>Portal jumplist backward<cr>" },
    { "<leader>i", "<cmd>Portal jumplist forward<cr>" },
  },
}
