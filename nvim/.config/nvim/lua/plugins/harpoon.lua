-- stylua: ignore
return {
  "ThePrimeagen/harpoon",
  config = function(_, opts)
    vim.keymap.set("n", "<leader>hm", require("harpoon.mark").add_file, { desc = "Mark file" })
    vim.keymap.set("n", "<leader>hh", require("harpoon.ui").toggle_quick_menu, { desc = "List marks" })
    vim.keymap.set("n", "<leader>hn", function() require("harpoon.ui").nav_prev() end, { desc = "Next mark" })
    vim.keymap.set("n", "<leader>ho", function() require("harpoon.ui").nav_next() end, { desc = "Prev mark" })
    vim.keymap.set("n", "<leader>h1", function() require("harpoon.ui").nav_file(1) end, { desc = "Go to mark 1" })
    vim.keymap.set("n", "<leader>h2", function() require("harpoon.ui").nav_file(2) end, { desc = "Go to mark 2" })
    vim.keymap.set("n", "<leader>h3", function() require("harpoon.ui").nav_file(3) end, { desc = "Go to mark 3" })
    vim.keymap.set("n", "<leader>h4", function() require("harpoon.ui").nav_file(4) end, { desc = "Go to mark 4" })
    vim.keymap.set("n", "<leader>h5", function() require("harpoon.ui").nav_file(5) end, { desc = "Go to mark 4" })
    vim.keymap.set("n", "<leader>h6", function() require("harpoon.ui").nav_file(6) end, { desc = "Go to mark 4" })
  end,
}
