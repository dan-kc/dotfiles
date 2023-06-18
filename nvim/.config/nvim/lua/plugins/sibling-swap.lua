return {
  "Wansmer/sibling-swap.nvim",
  opts = {
    keymaps = {
      ["<space>."] = "swap_with_right",
      ["<space>,"] = "swap_with_left_with_opp",
    },
  },
  dependencies = { "nvim-treesitter" },
}
