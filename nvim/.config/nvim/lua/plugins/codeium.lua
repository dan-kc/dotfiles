return {
  "Exafunction/codeium.vim",
  config = function()
    vim.keymap.set("i", "<c-g>", function()
      return vim.fn["codeium#Accept"]()
    end, { expr = true })
    --TODO: add cycle ability, the code below doesn;t work
    -- vim.keymap.set("i", "<c-.>", function()
    --   return vim.fn["codeium#CycleCompletions"](1)
    -- end, { expr = true })
    -- vim.keymap.set("i", "<c-,>", function()
    --   return vim.fn["codeium#CycleCompletions"](-1)
    -- end, { expr = true })
    vim.g.codeium_enabled = false -- initial state
  end,
}
