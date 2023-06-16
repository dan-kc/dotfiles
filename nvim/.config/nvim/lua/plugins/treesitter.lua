return {
  "nvim-treesitter/nvim-treesitter",
  keys = {
    { "<c-h>", desc = "Increment selection" },
  },
  ---@type TSConfig
  opts = {
    context_commentstring = { enable = true, enable_autocmd = false },
    ensure_installed = {
      "go",
      "bash",
      "html",
      "javascript",
      "json",
      "lua",
      "markdown",
      "markdown_inline",
      "query",
      "regex",
      "tsx",
      "typescript",
      "vim",
      "yaml",
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-h>",
        node_incremental = "<C-h>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    },
  },
}
