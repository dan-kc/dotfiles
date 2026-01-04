{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./fonts.nix
    ./zsh
  ];

  # https://github.com/tinted-theming/base16-schemes
  # colorScheme = inputs.nix-colors.colorSchemes.kanagawa;
  # colorScheme = inputs.nix-colors.colorSchemes.ashes;
  # colorScheme = inputs.nix-colors.colorSchemes.atelier-cave;
  # colorScheme = inputs.nix-colors.colorSchemes.atelier-forest; # 6/10
  # colorScheme = inputs.nix-colors.colorSchemes.atlas; # 5/10
  # colorScheme = inputs.nix-colors.colorSchemes.ayu-dark; # 7/10
  # colorScheme = inputs.nix-colors.colorSchemes.blueforest; # 7/10
  # colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha; # 8/10
  # colorScheme = inputs.nix-colors.colorSchemes.codeschool;  # 7/10
  # colorScheme = inputs.nix-colors.colorSchemes.danqing; # 7/10
  # colorScheme = inputs.nix-colors.colorSchemes.darcula; # 6/10
  # colorScheme = inputs.nix-colors.colorSchemes.darkmoss; # 8/10
  # colorScheme = inputs.nix-colors.colorSchemes.darktooth; # 7/10
  # colorScheme = inputs.nix-colors.colorSchemes.decaf; # 6/10
  # colorScheme = inputs.nix-colors.colorSchemes.dracula; # 8/10
  # colorScheme = inputs.nix-colors.colorSchemes.eighties; # 6/10
  # colorScheme = inputs.nix-colors.colorSchemes.eris; # 6/10
  # colorScheme = inputs.nix-colors.colorSchemes.espresso; # 6/10
  # colorScheme = inputs.nix-colors.colorSchemes.eva; # 8/10
  # colorScheme = inputs.nix-colors.colorSchemes.everforest; # 9/10
  # colorScheme = inputs.nix-colors.colorSchemes.flat; # 7/10
  # colorScheme = inputs.nix-colors.colorSchemes.gigavolt; # 7/10
  # colorScheme = inputs.nix-colors.colorSchemes.google-dark; # 7/10
  # colorScheme = inputs.nix-colors.colorSchemes.gotham; # 7/10
  # colorScheme = inputs.nix-colors.colorSchemes.gruber; # 8/10
  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-hard; # 7/10

  home.file = {
    ".config/starship.toml".source = ./starship.toml;
    ".config/atuin/config.toml".source = ./atuin.toml;
    ".config/theme.yaml".text = ''
      base00: "${config.colorScheme.palette.base00}"
      base01: "${config.colorScheme.palette.base01}"
      base02: "${config.colorScheme.palette.base02}"
      base03: "${config.colorScheme.palette.base03}"
      base04: "${config.colorScheme.palette.base04}"
      base05: "${config.colorScheme.palette.base05}"
      base06: "${config.colorScheme.palette.base06}"
      base07: "${config.colorScheme.palette.base07}"
      base08: "${config.colorScheme.palette.base08}"
      base09: "${config.colorScheme.palette.base09}"
      base0A: "${config.colorScheme.palette.base0A}"
      base0B: "${config.colorScheme.palette.base0B}"
      base0C: "${config.colorScheme.palette.base0C}"
      base0D: "${config.colorScheme.palette.base0D}"
      base0E: "${config.colorScheme.palette.base0E}"
      base0F: "${config.colorScheme.palette.base0F}"
    '';
  };

  nixpkgs.overlays = [
    (final: prev: {
      neovim = inputs.neovim.packages."${pkgs.system}".default;
      flake-gen = inputs.flake-gen.packages."${pkgs.system}".default;
      jt = inputs.jt.packages."${pkgs.system}".default;
      tv = inputs.television.packages."${pkgs.system}".default;
    })
  ];

  home.packages = with pkgs; [
    bandwhich
    bruno
    claude-code
    delta
    difftastic
    dua
    eza
    fd
    flake-gen
    fzf
    gh
    imagemagick
    jt
    jujutsu
    lazydocker
    lazygit
    neovim
    ripgrep
    starship
    tv
    qpdf
    zoxide
  ];

  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
  };

  programs.diff-so-fancy = {
    enable = true;
    enableGitIntegration = true;
    settings = {
      markEmptyLines = true;
    };
  };
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Daniel Cox";
        email = "63171098+dan-kc@users.noreply.github.com";
      };
      interactive = {
        singleKey = true;
      };
      init = {
        defaultBranch = "main";
      };
      color = {
        ui = "auto";
      };
      status = {
        branch = true;
        showStash = true;
        showUntrackedFiles = "all";
      };
    };
  };

  # Never change
  home.stateVersion = "24.05";
}
