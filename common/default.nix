{
  pkgs,
  inputs,
  lib,
  ...
}:
let
  google-cloud-with-plugins = pkgs.google-cloud-sdk.withExtraComponents (
    with pkgs.google-cloud-sdk.components;
    [
      gke-gcloud-auth-plugin
    ]
  );
in

{
  imports = [
    ./fonts.nix
    inputs.sops-nix.homeManagerModules.sops
  ];

  home.file = {
    ".zshrc".source = ./zsh/.zshrc;
    "zsh_modules".source = ./zsh/zsh_modules;
    ".config/starship.toml".source = ./starship.toml;
    ".config/yazi/yazi.toml".source = ./yazi/yazi.toml;
    ".config/yazi/keymap.toml".source = ./yazi/keymap.toml;
    ".config/yazi/init.lua".source = ./yazi/init.lua;
    ".config/lazygit/config.yml".source = ./lazygit.yml;
    ".config/atuin/config.toml".source = ./atuin.toml;
    ".config/wezterm".source = ./wezterm;
    ".config/alacritty.toml".source = ./alacritty.toml;
  };

  home.sessionVariables = {
    SRC_ENDPOINT = "https://sourcegraph.com";
    EDITOR = "nvim";
  };

  nixpkgs.overlays = [
    (final: prev: {
      neovim = inputs.neovim.packages."${pkgs.system}".default;
    })
    (final: prev: {
      wezterm = inputs.wezterm.packages."${pkgs.system}".default;
    })
    (final: prev: {
      zen = inputs.zen-browser.packages."${pkgs.system}".default;
    })
    (final: prev: {
      yazi = inputs.yazi.packages."${pkgs.system}".default;
    })
  ];

  home.packages = with pkgs; [
    alacritty
    anki
    vlc
    wezterm
    neovim
    zen
    atuin
    yazi
    zsh
    tree
    fzf
    lazygit
    lazydocker
    eza
    fd
    ripgrep
    zoxide
    starship
    trash-cli
    k3s
    gh
    fnm
    gcc
    bandwhich
    dua
    jq
    just
    miniserve
    rsync
    src-cli
    opentofu
    packer
    unzip
    git-open
    ripdrag
    # ragenix
    difftastic
    pass
    gnupg # Currently only use for pass, which i only use for gpg, which I only use for vault.
    google-cloud-with-plugins
    hurl
    unzip
    git-filter-repo
    direnv
    zellij
    tmux
    sway
  ];

  programs.yazi = {
    enable = true;
    plugins = {
      git = pkgs.yaziPlugins.git;
      starship = pkgs.yaziPlugins.starship;
    };
  };
  programs.git = {
    enable = true;
    userName = "Daniel Cox";
    userEmail = "63171098+dan-kc@users.noreply.github.com";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      color = {
        ui = "auto";
      };
    };
  };
}
