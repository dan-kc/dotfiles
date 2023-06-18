return {
  "cbochs/portal.nvim",
  -- Optional dependencies
  opts = {
    labels = { "a", "r", "s", "t", "n", "e", "i", "o" },
    window_options = {
      relative = "cursor",
      width = 80,
      height = 5,
      col = 2,
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
