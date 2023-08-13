return {
  "vimwiki/vimwiki",
  init = function()
    vim.g.vimwiki_global_ext = 0
    vim.g.vimwiki_list = {
      {
        path = "~/notes/wiki/",
        syntax = "markdown",
        ext = ".md",
      },
    }
  end,
  keys = {
    -- { "<leader>n", "<cmd>VimwikiIndex<cr>", desc = "Notes index" },
  },
}
