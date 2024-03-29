local set = vim.keymap.set

-- better save commands
set("n", "<leader>z", "ZZ")
set("v", "<leader>z", "<esc>ZZ")

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- buffers
set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
set("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Clear search with <esc>
set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- better up/down
set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
set("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- Resize window using <shift> arrow keys
set("n", "<S-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
set("n", "<S-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
set("n", "<S-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
set("n", "<S-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

set("n", "<leader>wx", "<C-w>x", { desc = "Swap window with next" })
set("n", "<leader>ux", ":set cursorline!<CR>", { desc = "Toggle cursor line" })
set("n", "<leader>ul", ":set number!<CR>", { desc = "Toggle cursor line" })
set("n", "<leader>qo", ":copen<CR>", { desc = "Open list" })
set("n", "<leader>qn", ":cnext<CR>", { desc = "Next item" })
set("n", "<leader>qp", ":cprev<CR>", { desc = "Prev item" })

--keywordprg
set("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- better indenting
set("v", "<", "<gv")
set("v", ">", ">gv")

-- highlight last pasted line
set("n", "gV", "'[V']")

-- lazy
set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

set("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
set("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })
set("n", "<leader>o", "<cmd>only<cr>", { desc = "Only" })
set("n", "<leader>|", "<cmd>vsplit<cr>", { desc = "Vertical Split" })
set("n", "<leader>-", "<cmd>split<cr>", { desc = "Vertical Split" })

set("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
set("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
