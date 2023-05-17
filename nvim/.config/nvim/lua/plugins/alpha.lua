return {
  enabled = false,
  "goolord/alpha-nvim",
  dependencies = {
    "is0n/fm-nvim",
    "nvim-telescope/telescope.nvim",
  },
  event = "VimEnter",
  opts = function()
    local dashboard = require("alpha.themes.dashboard")
    local logo = [[
  _                                            _                
 | |                                          | |               
 | | __   ___    ___    _ __     ___        __| |   ___  __   __
 | |/ /  / _ \  / _ \  | '_ \   / _ \      / _` |  / _ \ \ \ / /
 |   <  |  __/ | (_) | | | | | |  __/  _  | (_| | |  __/  \ V / 
 |_|\_\  \___|  \___/  |_| |_|  \___| (_)  \__,_|  \___|   \_/  
                                                                
    ]]

    dashboard.section.header.val = vim.split(logo, "\n", {})
    dashboard.section.buttons.val = {
      -- { "<leader>ff", Util.telescope("files", { cwd = false }), desc = "Find Files (cwd)" },
      dashboard.button("f", " " .. " Find file", ":Telescope git_files <CR>"),
      dashboard.button("e", " " .. " Explore", ":Xplr <CR>"),
      dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
      dashboard.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
      dashboard.button("l", "󰒲 " .. " Lazy", ":Lazy<CR>"),
      dashboard.button("q", " " .. " Quit", ":qa<CR>"),
    }
    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = "AlphaButtons"
      button.opts.hl_shortcut = "AlphaShortcut"
    end
    dashboard.section.footer.opts.hl = "Type"
    dashboard.section.header.opts.hl = "AlphaHeader"
    dashboard.section.buttons.opts.hl = "AlphaButtons"
    dashboard.opts.layout[1].val = 6
    return dashboard
  end,
  config = function(_, dashboard)
    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == "lazy" then
      vim.cmd.close()
      vim.api.nvim_create_autocmd("User", {
        pattern = "AlphaReady",
        callback = function()
          require("lazy").show()
        end,
      })
    end

    require("alpha").setup(dashboard.opts)
  end,
}
