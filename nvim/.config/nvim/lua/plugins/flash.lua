return {
  "folke/flash.nvim",
  -- stylua: ignore
  keys = {
    { "'", mode = { "n", "x", "o" }, function() require("flash").jump({continue = true}) end,desc = "Resume last search" },
  },
}
