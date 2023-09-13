return {
  enabled = true,
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
    dashboard.section.buttons.val = {}
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
