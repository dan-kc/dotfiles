local window_management = {
  name = "window manager",
  mode = "n",
  body = "<leader>ww",
  heads = {
    { "n", "<C-w>h", { desc = "jump left" } },
    { "e", "<C-w>j", { desc = "jump down" } },
    { "i", "<C-w>k", { desc = "jump up" } },
    { "o", "<C-w>l", { desc = "jump right" } },
    { "<Up>", "<C-w>+", { desc = "increase height" } },
    { "<Down>", "<C-w>-", { desc = "decrease height" } },
    { "<Left>", "<C-w>>", { desc = "increase width" } },
    { "<Right>", "<C-w><", { desc = "decrease width" } },
    -- { "O", "<C-w>o", { desc = "close all other windows" } },
    -- { "x", "<C-w>x", { desc = "swap current window with next" } },
    -- { "|", "<C-w>v", { desc = "split window vertically" } },
    -- { "-", "<C-w>s", { desc = "split window horizontally" } },
    -- { "q", "<C-w>q", { desc = "close window" } },
    -- { "w", "<C-w>q", { desc = "close window" } },
    -- { "d", "<C-w>q", { desc = "close window" } },
  },
}

local harpoon = {
  name = "Hydra's name",
  mode = "n",
  body = "<leader>hh",
  heads = {
    { "n", "n", { desc = "Next mark" } },
    { "o", "<leader>ho", { desc = "Prev mark" } },
  },
}

return {
  "anuvyklack/hydra.nvim",
  enabled = true,
  keys = {
    { "<leader>w" },
    -- { "<leader>h" },
  },
  config = function(_, _)
    local Hydra = require("hydra")
    Hydra(window_management)
    -- Hydra(harpoon)
  end,
}
