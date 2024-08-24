## `ftplugin` directory

Files in this directory will be sourced when you open a file of that filetype.
The name of the file needs to have the same name as the filetype e.g. rust.lua.

You can find the filetype of a file you're in if you run:
```:set filetype?```
The file is sourced EVERY time you open tha file, so things you want to only 
source once, make sure you do a check like so:
```
if vim.g.did_load_commands_plugin then
  return
end
vim.g.did_load_commands_plugin = true
```
