# Neovim loading mechanisms:

- [`:h initialization`](https://neovim.io/doc/user/starting.html#initialization)
- [`:h runtimepath`](https://neovim.io/doc/user/options.html#'runtimepath')
- [`:h packadd`](https://neovim.io/doc/user/repeat.html#%3Apackadd)

nvim directory structure:

```sh
── nvim
  ├── ftplugin # Sourced when opening a file type
  │  └── <filetype>.lua
  ├── init.lua # Always sourced
  ├── lua # Shared library modules
  │  └── user
  │     └── <lib>.lua
  ├── plugin # Automatically sourced at startup
  │  ├── autocommands.lua
  │  ├── commands.lua
  │  ├── keymaps.lua
  │  ├── plugins.lua # Plugins that require a `setup` call
  │  └── <plugin-config>.lua # Plugin configurations
  └── after # Empty in this template
     ├── plugin # Sourced at the very end of startup (rarely needed)
     └── ftplugin # Sourced when opening a filetype, after sourcing ftplugin scripts
```

# Initialization order

This derivation creates an `init.lua` as follows:

1. Add `nvim/lua` to the `runtimepath`.
1. Add the content of `nvim/init.lua`.
1. Add `nvim/*` to the `runtimepath`.
1. Add `nvim/after` to the `runtimepath`.

This means that modules in `nvim/lua` can be `require`d in `init.lua` and `nvim/*/*.lua`.

Modules in `nvim/plugin/` are sourced automatically, as if they were plugins.
Because they are added to the runtime path at the end of the resulting `init.lua`,
Neovim sources them _after_ loading plugins.
