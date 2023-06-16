-- Replace default config to enable multi-directional search

return {
  "ggandor/leap.nvim",
  keys = {
    {
      "<leader><space>",
      mode = { "n", "x", "o" },
      function()
        local focusable_windows_on_tabpage = vim.tbl_filter(function(win)
          return vim.api.nvim_win_get_config(win).focusable
        end, vim.api.nvim_tabpage_list_wins(0))
        require("leap").leap({ target_windows = focusable_windows_on_tabpage })
        vim.api.nvim_feedkeys("zz", "n", false)
      end,
      desc = "Leap anywhere",
    },
    { "gs", false },
  },
}
