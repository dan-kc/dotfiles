-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local telescopeConfig = require("telescope.config")
local actions = require('telescope.actions')

-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

-- I want to search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")
-- I don't want to search in the `.git` directory.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

require('telescope').setup {
	defaults = {

		vimgrep_arguments = vimgrep_arguments,

		multi_icon = "",
		layout_strategy = "flex",
		scroll_strategy = "cycle",
		selection_strategy = "reset",
		winblend = 0,
		layout_config = {
			vertical = {
				mirror = true,
			},
			center = {
				mirror = true,
			},
		},
		preview = {
			msg_bg_fillchar = " ",
		},
		history = {
			cycle_wrap = true,
		},
		cache = false,
		mappings = {
			i = {
				['<C-u>'] = false,
				['<C-d>'] = false,
			},
			n = {
				["q"] = actions.close
			},
		},
	},
	pickers = {
		find_files = {
			theme = "dropdown",
			previewer = false,
			-- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
			find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
		},
		help_tags = {
			theme = "dropdown",
			previewer = false,
		},
		oldfiles = {
			theme = "dropdown",
			previewer = false,
		},
		buffers = {
			theme = "dropdown",
			previewer = false,
		},
	},
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>/', function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
		winblend = 10,
		previewer = false,
	})
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', ';h', require('telescope.builtin').help_tags, { desc = 'Search [H]elp files' })
vim.keymap.set('n', ';f', require('telescope.builtin').find_files, { desc = 'Search [F]iles' })
vim.keymap.set('n', ';w', require('telescope.builtin').grep_string, { desc = 'Search current [W]ord' })
vim.keymap.set('n', ';g', require('telescope.builtin').live_grep, { desc = 'Search by [G]rep' })
vim.keymap.set('n', ';d', require('telescope.builtin').diagnostics, { desc = 'Search [D]iagnostics' })
vim.keymap.set('n', ';r', require('telescope.builtin').oldfiles, { desc = 'Find recently opened [F]iles' })
vim.keymap.set('n', ';b', require('telescope.builtin').buffers, { desc = 'Find existing [B]uffers' })
