return {
  "is0n/fm-nvim",
  config = function(_, opts)
    vim.keymap.set("n", "<leader>e", "<cmd>Xplr<cr>", { desc = "Open explorer" })
  end,
}
