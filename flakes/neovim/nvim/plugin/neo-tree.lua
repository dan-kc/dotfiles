if vim.g.did_load_neotree_plugin then
  return
end
vim.g.did_load_neotree_plugin = true

local icons = require('user.icons')

require('neo-tree').setup {
  default_component_configs = {
    container = {
      enable_character_fade = true,
    },
    indent = {
      indent_size = 2,
      padding = 1,
      with_markers = true,
      indent_marker = "│",
      last_indent_marker = "└",
      highlight = "NeoTreeIndentMarker",
      with_expanders = true,
      expander_collapsed = icons.more.chevronRight,
      expander_expanded = icons.more.chevronDown,
      expander_highlight = "NeoTreeExpander",
    },
    icon = {
      folder_closed = icons.more.folder,
      folder_open = icons.more.folderOpen,
      folder_empty = icons.more.folderOpenNoBg,
      default = icons.more.fileNoLinesBg,
      highlight = "NeoTreeFileIcon",
    },
    modified = {
      symbol = icons.git.mod,
      highlight = "NeoTreeModified",
    },
    name = {
      trailing_slash = false,
      use_git_status_colors = true,
      highlight = "NeoTreeFileName",
    },
    git_status = {
      symbols = {
        -- Change type
        added = icons.git.add,
        modified = icons.git.change,
        deleted = icons.git.remove,
        renamed = icons.git.rename,
        -- Status type
        untracked = icons.git.untracked,
        ignored = icons.git.ignore,
        unstaged = icons.git.unstaged,
        staged = icons.git.staged,
        conflict = icons.git.conflict,
      },
    },
    file_size = {
      enabled = true,
      required_width = 64, -- min width of window required to show this column
    },
    type = {
      enabled = true,
      required_width = 122, -- min width of window required to show this column
    },
    last_modified = {
      enabled = true,
      required_width = 88, -- min width of window required to show this column
    },
    created = {
      enabled = true,
      required_width = 110, -- min width of window required to show this column
    },
    symlink_target = {
      enabled = false,
    },
  },
  mappings = {
    ["<cr>"] = "open",
    ["S"] = "open_split",
    ["s"] = "open_vsplit",
    ["C"] = "close_node",
    ["z"] = "close_all_nodes",
    ["Z"] = "expand_all_nodes",
    ["a"] = { "add", config = { show_path = "relative" } },
    ["A"] = "add_directory",
    ["d"] = "delete",
    ["r"] = "rename",
    ["y"] = "copy_to_clipboard",
    ["x"] = "cut_to_clipboard",
    ["p"] = "paste_from_clipboard",
    ["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
    -- ["c"] = { "copy", config = { show_path = "none" -- "none", "relative", "absolute" }}
    ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
    ["q"] = "close_window",
    ["R"] = "refresh",
    ["?"] = "show_help",
    ["<"] = "prev_source",
    [">"] = "next_source",
    ["i"] = "show_file_details",
  },
  filesystem = {
    filtered_items = {
      visible = true, -- when true, they will just be displayed differently than normal items
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_hidden = false,
      never_show = {
        --".DS_Store",
      },
    },
    follow_current_file = {
      enabled = true,
      leave_dirs_open = true,
    },
    group_empty_dirs = false,
    hijack_netrw_behavior = "open_default",
    window = {
      mappings = {
        ["<bs>"] = "navigate_up",
        ["."] = "set_root",
        ["H"] = "toggle_hidden",
        ["/"] = "fuzzy_finder",
        ["D"] = "fuzzy_finder_directory",
        ["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
        -- ["D"] = "fuzzy_sorter_directory",
        ["f"] = "filter_on_submit",
        ["<c-x>"] = "clear_filter",
        ["[g"] = "prev_git_modified",
        ["]g"] = "next_git_modified",
        ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
        ["oc"] = { "order_by_created", nowait = false },
        ["od"] = { "order_by_diagnostics", nowait = false },
        ["og"] = { "order_by_git_status", nowait = false },
        ["om"] = { "order_by_modified", nowait = false },
        ["on"] = { "order_by_name", nowait = false },
        ["os"] = { "order_by_size", nowait = false },
        ["ot"] = { "order_by_type", nowait = false },
      },
    },
  },
  buffers = {
    follow_current_file = {
      enabled = true,         -- This will find and focus the file in the active buffer every time
      leave_dirs_open = true, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
    },
    group_empty_dirs = true,
    show_unloaded = true,
  },
}
local opts = {
  toggle = true,
  dir = vim.loop.cwd(),
  position = "current",
  reveal = true,
}

vim.keymap.set('n', '<leader>e', function() require('neo-tree.command').execute(opts) end, { desc = 'Toggle neo-tree' })
