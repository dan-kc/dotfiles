return {
  "cbochs/portal.nvim",
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
    {
      "<leader>O",
      function()
        require("portal").tunnel({
          require("portal.builtin").grapple.query({ max_results = 1 }),
          require("portal.builtin").jumplist.query({ max_results = 3 }),
        })
      end,
      desc = "Portal somewhere",
    },
  },
}
