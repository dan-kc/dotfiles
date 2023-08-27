return {
  "danymat/neogen",
  dependencies = "nvim-treesitter/nvim-treesitter",
  config = true,
  keys = {
    { "gaa", "<cmd>Neogen<cr>", desc = "Annotate" },
    { "gac", "<cmd>Neogen class<cr>", desc = "Annotate class" },
    { "gaf", "<cmd>Neogen func<cr>", desc = "Annotate function" },
    { "gat", "<cmd>Neogen type<cr>", desc = "Annotate type" },
    { "gam", "<cmd>Neogen file<cr>", desc = "Annotate module/file" },
  },
}
