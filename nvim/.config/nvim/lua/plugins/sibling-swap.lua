return {
  "Wansmer/sibling-swap.nvim",
  opts = {
    use_default_keymaps = false,
  },
  config = function(_, opts)
    vim.keymap.set("n", "<space>.", require("sibling-swap").swap_with_right, { desc = "Swap node with right" })
    vim.keymap.set("n", "<space>,", require("sibling-swap").swap_with_left, { desc = "Swap node with left" })
  end,
  dependencies = { "nvim-treesitter" },
}
