# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{ inputs }:
final: prev:
with final.pkgs.lib;
let
  pkgs = final;

  # Use this to create a plugin from a flake input
  mkNvimPlugin =
    src: pname:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };

  # Make sure we use the pinned nixpkgs instance for wrapNeovimUnstable,
  # otherwise it could have an incompatible signature when applying this overlay.
  pkgs-wrapNeovim = inputs.nixpkgs.legacyPackages.${pkgs.system};

  # This is the helper function that builds the Neovim derivation.
  mkNeovim = pkgs.callPackage ./mkNeovim.nix { inherit pkgs-wrapNeovim; };

  all-plugins = with pkgs.vimPlugins; [
    neo-tree-nvim
    nvim-treesitter.withAllGrammars
    luasnip
    nvim-cmp
    cmp_luasnip
    lspkind-nvim
    cmp-nvim-lsp
    cmp-nvim-lsp-signature-help
    cmp-buffer
    cmp-path
    cmp-nvim-lua
    cmp-cmdline
    cmp-cmdline-history

    gitsigns-nvim
    # vim-fugitive I don't think i need.
    telescope-nvim
    telescope-fzy-native-nvim
    lualine-nvim
    nvim-navic
    # statuscol-nvim dont think i need.
    # nvim-treesitter-context
    nvim-treesitter-textobjects
    nvim-ts-context-commentstring

    vim-unimpaired
    nvim-surround
    nvim-unception

    # Packages that are needed for other plugins
    statuscol-nvim
    sqlite-lua
    plenary-nvim
    nvim-web-devicons
    vim-repeat
    which-key-nvim

    # Stuff I added
    conform-nvim
    flash-nvim
    nvim-lspconfig
    treesj
    obsidian-nvim
    mini-base16
    base16-nvim
    transparent-nvim
    indent-blankline-nvim
    mini-indentscope
    barbecue-nvim
    dressing-nvim

  ];

  extraPackages = with pkgs; [
    lua-language-server
    stylua

    nil
    nixfmt-rfc-style

    rust-analyzer
    rustfmt

    typescript-language-server
    nodePackages.prettier

    gopls
    gofumpt

    taplo
  ];
in
{
  # This is the neovim derivation
  # returned by the overlay
  nvim-pkg = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages;
  };

  # This can be symlinked in the devShell's shellHook
  nvim-luarc-json = final.mk-luarc-json {
    plugins = all-plugins;
  };

  # You can add as many derivations as you like.
  # Use `ignoreConfigRegexes` to filter out config
  # files you would not like to include.
  #
  # For example:
  #
  # nvim-pkg-no-telescope = mkNeovim {
  #   plugins = [];
  #   ignoreConfigRegexes = [
  #     "^plugin/telescope.lua"
  #     "^ftplugin/.*.lua"
  #   ];
  #   inherit extraPackages;
  # };
}
