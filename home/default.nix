{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    ./fonts.nix
    inputs.sops-nix.homeManagerModules.sops
    inputs.nix-colors.homeManagerModules.default
  ];
  colorScheme = inputs.nix-colors.colorSchemes.rose-pine;
  home.username = "daniel";
  home.homeDirectory = "/home/daniel";
  home.file = {
    ".config/hypr".source = ./hyprland;
    "wluma/config.toml".source = ./wluma.toml;
    ".zshrc".source = ./zsh/.zshrc;
    "zsh_modules".source = ./zsh/zsh_modules;
    ".config/starship.toml".source = ./starship.toml;
    ".config/yazi/yazi.toml".source = ./yazi/yazi.toml;
    ".config/yazi/keymap.toml".source = ./yazi/keymap.toml;
    ".config/yazi/init.lua".source = ./yazi/init.lua;
    ".config/lazygit/config.yml".source = ./lazygit.yml;
    ".config/atuin/config.toml".source = ./atuin.toml;
    ".config/wezterm".source = ./wezterm;
    ".config/alacritty.toml".text = ''
      [font]
      normal = { family = "Hack Nerd Font" } 
      builtin_box_drawing = false
      size = 25

      [window]
      padding = { x = 20, y = 20 }
      dynamic_padding = true
      opacity = 1

      [selection]
      save_to_clipboard = true

      [keyboard]
      bindings = [
        {key = "Plus", mods = "Control|Shift", action = "IncreaseFontSize"} # QMK inputs "Control|Shift Equals" when you try to "Control Plus". For some reason this fixes it.
      ]

      # Base16 {{scheme-name}} - alacritty color config

      [colors]
      draw_bold_text_with_bright_colors = false

      # Default colors
      [colors.primary]
      background = '#${config.colorScheme.palette.base00}'
      foreground = '#${config.colorScheme.palette.base05}'

      # Colors the cursor will use if `custom_cursor_colors` is true
      [colors.cursor]
      text = '#${config.colorScheme.palette.base00}'
      cursor = '#${config.colorScheme.palette.base05}'

      # Normal colors
      [colors.normal]
      black = '#${config.colorScheme.palette.base00}'
      red = '#${config.colorScheme.palette.base08}'
      green = '#${config.colorScheme.palette.base0B}'
      yellow = '#${config.colorScheme.palette.base0A}'
      blue = '#${config.colorScheme.palette.base0D}'
      magenta = '#${config.colorScheme.palette.base0E}'
      cyan = '#${config.colorScheme.palette.base0C}'
      white = '#${config.colorScheme.palette.base05}'

      # Bright colors
      [colors.bright]
      black = '#${config.colorScheme.palette.base03}'
      red = '#${config.colorScheme.palette.base09}'
      green = '#${config.colorScheme.palette.base01}'
      yellow = '#${config.colorScheme.palette.base02}'
      blue = '#${config.colorScheme.palette.base04}'
      magenta = '#${config.colorScheme.palette.base06}'
      cyan = '#${config.colorScheme.palette.base0F}'
      white = '#${config.colorScheme.palette.base07}'
    '';
    ".config/direnv/direnv.toml".source = ./direnv.toml;

  };

  nixpkgs.overlays = [
    (final: prev: {
      neovim = inputs.neovim.packages."${pkgs.system}".default;
      wezterm = inputs.wezterm.packages."${pkgs.system}".default;
      zen = inputs.zen-browser.packages."${pkgs.system}".default;
      yazi = inputs.yazi.packages."${pkgs.system}".default;
      flake-gen = inputs.flake-gen.packages."${pkgs.system}".default;
      jt = inputs.jt.packages."${pkgs.system}".default;
      flavours = inputs.flavours.packages."${pkgs.system}".default;
    })
  ];
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "vivaldi"
      "slack"
      "postman"
      "packer"
      "discord"
      "libsciter"
      "obsidian"
    ];

  home.packages = with pkgs; [
    (import ./app-launcher.nix { inherit pkgs; })
    flavours
    bruno
    yaak
    # clipboard-jh
    wl-clipboard
    vivaldi
    bemenu
    libnotify
    mako
    hyprpaper
    hyprshot
    hyprsunset
    thunderbird
    slack
    protonmail-bridge
    postman
    gnumake
    tmux
    awscli2
    discord
    eww
    wluma
    udiskie
    ddcutil
    brightnessctl
    matugen
    obsidian
    jt
    alacritty
    anki
    vlc
    wezterm
    neovim
    zen
    atuin
    yazi
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
    difftastic
    pass
    gnupg # Currently only use for pass, which i only use for gpg, which I only use for vault.
    hurl
    unzip
    git-filter-repo
    direnv
    ruplacer
    flake-gen
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
  # Never change
  home.stateVersion = "24.05";
}
