return {
  "goolord/alpha-nvim",
  enabled = false,
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

    dashboard.section.header.val = vim.split(logo, "\n")
    return dashboard
  end,
}
