-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Setup nvim-tree
require("nvim-tree").setup({
  view = {
    mappings = {
      list = {
        { key = "v", action = "vsplit" },
        { key = "n", action = "cd" },
        { key = "<C-]>", action = "" },
      },
    },
  },
  actions = {
    open_file = {
      quit_on_open = true,
    }
  }
})

vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true })
