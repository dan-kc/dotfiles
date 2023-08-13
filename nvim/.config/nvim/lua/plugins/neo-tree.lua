return {
  "nvim-neo-tree/neo-tree.nvim",
  enabled = false,
  opts = {
    filesystem = {
      filtered_items = {
        visible = true, -- when true, they will just be displayed differently than normal items
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = false, -- only works on Windows for hidden files/directories
      },
      components = {
        harpoon_index = function(config, node, state)
          local Marked = require("harpoon.mark")
          local path = node:get_id()
          local succuss, index = pcall(Marked.get_index_of, path)
          if succuss and index and index > 0 then
            return {
              text = string.format(" ⥤ %d", index), -- <-- Add your favorite harpoon like arrow here
              highlight = config.highlight or "NeoTreeDirectoryIcon",
            }
          else
            return {}
          end
        end,
      },
      renderers = {
        file = {
          { "icon" },
          { "name", use_git_status_colors = true },
          { "harpoon_index" }, --> This is what actually adds the component in where you want it
          { "diagnostics" },
          { "git_status", highlight = "NeoTreeDimText" },
        },
      },
      commands = {
        system_open = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          path = vim.fn.shellescape(path)
          -- macOs: open file in default application in the background.
          vim.api.nvim_command("silent !open -g " .. path)
        end,
      },
    },
    window = {
      width = 80,
      mappings = {
        ["o"] = "system_open",
      },
    },
    event_handlers = {
      {
        event = "file_opened",
        handler = function(file_path)
          --auto close
          vim.cmd("Neotree close")
        end,
      },
    },
  },
}
