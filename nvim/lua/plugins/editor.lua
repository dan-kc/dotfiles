local icons = require("config.icons")
return {
  --  ╭──────────────────────────────────────────────────────────╮
  --  │                        telescope                         │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    keys = function()
      local builtin = require("telescope.builtin")
        -- stylua: ignore
      return {
        { "<leader>,", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Switch Buffer" },
        { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
        { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
        { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
        { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
        { '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
        { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
        { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
        { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
        { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
        { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
        { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Marks" },
        { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
        { "<leader>'", "<cmd>Telescope resume<cr>", desc = "Resume" },
        { "<leader>uc", function() builtin.colorscheme() end, desc = "Colorschemes" },
        { "<leader>ss", function() builtin.lsp_document_symbols() end, desc = "Symbols" },
        { "<leader>sg", function() builtin.live_grep({ cwd = false }) end, desc = "Grep" },
        { "<leader>/", function() builtin.oldfiles({ cwd = vim.loop.cwd() }) end, desc = "Recent" },
       -- { "<leader>fn", function() end, desc = "Find note", }, 
        { "<leader>ff", function() builtin.find_files({ cwd = false }) end, desc = "Find files", },
      }
    end,
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                         neo-tree                         │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "nvim-neo-tree/neo-tree.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({
            toggle = true,
            dir = vim.loop.cwd(),
            position = "current",
            reveal = true,
          })
        end,
        desc = "Explorer NeoTree",
      },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts = {
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
          visible = false, -- when true, they will just be displayed differently than normal items
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
          fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
            ["<down>"] = "move_cursor_down",
            ["<C-n>"] = "move_cursor_down",
            ["<up>"] = "move_cursor_up",
            ["<C-p>"] = "move_cursor_up",
          },
        },
      },
      buffers = {
        follow_current_file = {
          enabled = true, -- This will find and focus the file in the active buffer every time
          leave_dirs_open = true, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
        },
        group_empty_dirs = true,
        show_unloaded = true,
      },
    },
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                         diffview                         │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "sindrets/diffview.nvim",
    event = "VeryLazy",
    -- stylua: ignore start
    cmd = {
      "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles",
      "DiffviewFileHistory", "DiffviewRefresh"
    },
    -- stylua: ignore end
    config = true,
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffView" },
      { "<leader>gD", "<cmd>DiffviewFileHistory %<cr>", desc = "DiffviewFileHistory Current File" },
    },
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                        treesitter                        │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    event = "VeryLazy",
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = "all",
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
    config = function(_, opts)
      -- auto install languages
      if type(opts.ensure_installed) == "table" then
        ---@type table<string, boolean>
        local added = {}
        opts.ensure_installed = vim.tbl_filter(function(lang)
          if added[lang] then
            return false
          end
          added[lang] = true
          return true
        end, opts.ensure_installed)
      end
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  --  ╭──────────────────────────────────────────────────────────╮
  --  │                         nvim-bqf                         │
  --  ╰──────────────────────────────────────────────────────────╯
  {
    "kevinhwang91/nvim-bqf",
    event = "VeryLazy",
    dependencies = {
      "junegunn/fzf",
    },
  },

  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    opts = function()
      -- Define the path to the environment file
      local env_file_path = vim.fn.stdpath("config") .. "/.env"

      -- Function to read a specific environment variable from a file
      local function read_env_variable(variable_name)
        local file = io.open(env_file_path, "r")

        if file then
          for line in file:lines() do
            local name, value = line:match("^%s*([%w_]+)%s*=%s*(.+)%s*$")
            if name == variable_name then
              file:close()
              return value
            end
          end
          file:close()
        end
        return nil
      end

      -- Get the value of the 'KEY' environment variable from the file
      local key_value = read_env_variable("OPEN_AI_KEY")

      return {
        api_key_cmd = "echo " .. key_value,
      }
    end,

    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
}
