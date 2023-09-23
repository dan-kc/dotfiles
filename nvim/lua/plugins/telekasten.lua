return {
  "renerocksai/telekasten.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  enabled = false,
  keys = {
    { "<leader>fN", ":lua require('telekasten').find_notes()<CR>", desc = "Find notes" },
    { "<leader>sn", "<cmd>Telekasten search_notes<cr>", desc = "Search notes" },
    { "<leader>nm", "<cmd>Telekasten<cr>", desc = "Notes menu" },
    { "<leader>nn", "<cmd>Telekasten new_note<cr>", desc = "New note" },
    -- { "<leader>ny", "<cmd>Telekasten yank_notelink<cr>", desc = "Yank note link" },
    { "<leader>nr", "<cmd>Telekasten rename_note<cr>", desc = "Rename note" },
    -- { "<leader>nt", "<cmd>Telekasten toggle_todo<cr>", desc = "Toggle todo" },
    { "<leader>ni", "<cmd>Telekasten insert_link<cr>", desc = "Insert link" },
    { "<leader>nf", "<cmd>Telekasten follow_link<cr>", desc = "Follow link" },
  },
  opts = {
    home = vim.fn.expand("~/zettelkasten"),
  },
}
