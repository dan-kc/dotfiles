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
    ./starship.nix
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
  # colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-hard; # 7/10
  # colorScheme = inputs.nix-colors.colorSchemes.hardcore; # 7/10 borders not clear
  # colorScheme = inputs.nix-colors.colorSchemes.harmonic16-dark; # 7/10 
  # colorScheme = inputs.nix-colors.colorSchemes.hopscotch; # 8/10 
  # colorScheme = inputs.nix-colors.colorSchemes.horizon-dark; # 7/10 
  # colorScheme = inputs.nix-colors.colorSchemes.humanoid-dark; # 7/10 
  # colorScheme = inputs.nix-colors.colorSchemes.kanagawa; # 7/10 
  # colorScheme = inputs.nix-colors.colorSchemes.katy; # 8/10 very blue
  colorScheme = inputs.nix-colors.colorSchemes.materia; # 8/10
  # colorScheme = inputs.nix-colors.colorSchemes.material;
  # colorScheme = inputs.nix-colors.colorSchemes.material-darker;
  # colorScheme = inputs.nix-colors.colorSchemes.material-lighter;
  # colorScheme = inputs.nix-colors.colorSchemes.material-palenight;
  # colorScheme = inputs.nix-colors.colorSchemes.material-vivid;
  # colorScheme = inputs.nix-colors.colorSchemes.mellow-purple;
  # colorScheme = inputs.nix-colors.colorSchemes.mexico-light;
  # colorScheme = inputs.nix-colors.colorSchemes.mocha;
  # colorScheme = inputs.nix-colors.colorSchemes.monokai;
  # colorScheme = inputs.nix-colors.colorSchemes.mountain;
  # colorScheme = inputs.nix-colors.colorSchemes.nebula;
  # colorScheme = inputs.nix-colors.colorSchemes.nord;
  # colorScheme = inputs.nix-colors.colorSchemes.nova;
  # colorScheme = inputs.nix-colors.colorSchemes.ocean;
  # colorScheme = inputs.nix-colors.colorSchemes.oceanicnext;
  # colorScheme = inputs.nix-colors.colorSchemes.one-light;
  # colorScheme = inputs.nix-colors.colorSchemes.onedark;
  # colorScheme = inputs.nix-colors.colorSchemes.outrun-dark;
  # colorScheme = inputs.nix-colors.colorSchemes.oxocarbon-dark;
  # colorScheme = inputs.nix-colors.colorSchemes.oxocarbon-light;
  # colorScheme = inputs.nix-colors.colorSchemes.pandora;
  # colorScheme = inputs.nix-colors.colorSchemes.papercolor-dark;
  # colorScheme = inputs.nix-colors.colorSchemes.papercolor-light;
  # colorScheme = inputs.nix-colors.colorSchemes.paraiso;
  # colorScheme = inputs.nix-colors.colorSchemes.pasque;
  # colorScheme = inputs.nix-colors.colorSchemes.phd;
  # colorScheme = inputs.nix-colors.colorSchemes.pico;
  # colorScheme = inputs.nix-colors.colorSchemes.pinky;
  # colorScheme = inputs.nix-colors.colorSchemes.pop;
  # colorScheme = inputs.nix-colors.colorSchemes.porple;
  # colorScheme = inputs.nix-colors.colorSchemes.primer-dark;
  # colorScheme = inputs.nix-colors.colorSchemes.primer-dark-dimmed;
  # colorScheme = inputs.nix-colors.colorSchemes.primer-light;
  # colorScheme = inputs.nix-colors.colorSchemes.purpledream;
  # colorScheme = inputs.nix-colors.colorSchemes.qualia;
  # colorScheme = inputs.nix-colors.colorSchemes.railscasts;
  # colorScheme = inputs.nix-colors.colorSchemes.rebecca;
  # colorScheme = inputs.nix-colors.colorSchemes.rose-pine;
  # colorScheme = inputs.nix-colors.colorSchemes.rose-pine-dawn;
  # colorScheme = inputs.nix-colors.colorSchemes.rose-pine-moon;
  # colorScheme = inputs.nix-colors.colorSchemes.sagelight;
  # colorScheme = inputs.nix-colors.colorSchemes.sakura;
  # colorScheme = inputs.nix-colors.colorSchemes.sandcastle;
  # colorScheme = inputs.nix-colors.colorSchemes.selenized-black;
  # colorScheme = inputs.nix-colors.colorSchemes.selenized-dark;
  # colorScheme = inputs.nix-colors.colorSchemes.selenized-light;
  # colorScheme = inputs.nix-colors.colorSchemes.selenized-white;
  # colorScheme = inputs.nix-colors.colorSchemes.seti;
  # colorScheme = inputs.nix-colors.colorSchemes.shades-of-purple;
  # colorScheme = inputs.nix-colors.colorSchemes.shadesmear-dark;
  # colorScheme = inputs.nix-colors.colorSchemes.shadesmear-light;
  # colorScheme = inputs.nix-colors.colorSchemes.shapeshifter;
  # colorScheme = inputs.nix-colors.colorSchemes.silk-dark;
  # colorScheme = inputs.nix-colors.colorSchemes.silk-light;
  # colorScheme = inputs.nix-colors.colorSchemes.snazzy;
  # colorScheme = inputs.nix-colors.colorSchemes.solarflare;
  # colorScheme = inputs.nix-colors.colorSchemes.solarflare-light;
  # colorScheme = inputs.nix-colors.colorSchemes.solarized-dark;
  # colorScheme = inputs.nix-colors.colorSchemes.solarized-light;
  # colorScheme = inputs.nix-colors.colorSchemes.spaceduck;
  # colorScheme = inputs.nix-colors.colorSchemes.spacemacs;
  # colorScheme = inputs.nix-colors.colorSchemes.standardized-dark;
  # colorScheme = inputs.nix-colors.colorSchemes.standardized-light;
  # colorScheme = inputs.nix-colors.colorSchemes.stella;
  # colorScheme = inputs.nix-colors.colorSchemes.still-alive;
  # colorScheme = inputs.nix-colors.colorSchemes.summercamp;
  # colorScheme = inputs.nix-colors.colorSchemes.summerfruit-dark;
  # colorScheme = inputs.nix-colors.colorSchemes.summerfruit-light;
  # colorScheme = inputs.nix-colors.colorSchemes.synth-midnight-dark;
  # colorScheme = inputs.nix-colors.colorSchemes.synth-midnight-light;
  # colorScheme = inputs.nix-colors.colorSchemes.tango;
  # colorScheme = inputs.nix-colors.colorSchemes.tarot;
  # colorScheme = inputs.nix-colors.colorSchemes.tender;
  # colorScheme = inputs.nix-colors.colorSchemes.tokyo-city-dark;
  # colorScheme = inputs.nix-colors.colorSchemes.tokyo-city-light;
  # colorScheme = inputs.nix-colors.colorSchemes.tokyo-city-terminal-dark;
  # colorScheme = inputs.nix-colors.colorSchemes.tokyo-city-terminal-light;
  # colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-dark;
  # colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-light;
  # colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-storm;
  # colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-terminal-dark;
  # colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-terminal-light;
  # colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-terminal-storm;
  # colorScheme = inputs.nix-colors.colorSchemes.tokyodark;
  # colorScheme = inputs.nix-colors.colorSchemes.tokyodark-terminal;
  # colorScheme = inputs.nix-colors.colorSchemes.tomorrow;
  # colorScheme = inputs.nix-colors.colorSchemes.tomorrow-night;
  # colorScheme = inputs.nix-colors.colorSchemes.tomorrow-night-eighties;
  # colorScheme = inputs.nix-colors.colorSchemes.tube;
  # colorScheme = inputs.nix-colors.colorSchemes.twilight;
  # colorScheme = inputs.nix-colors.colorSchemes.unikitty-dark;
  # colorScheme = inputs.nix-colors.colorSchemes.unikitty-light;
  # colorScheme = inputs.nix-colors.colorSchemes.unikitty-reversible;
  # colorScheme = inputs.nix-colors.colorSchemes.uwunicorn;
  # colorScheme = inputs.nix-colors.colorSchemes.vice;
  # colorScheme = inputs.nix-colors.colorSchemes.vulcan;
  # colorScheme = inputs.nix-colors.colorSchemes.windows-10;
  # colorScheme = inputs.nix-colors.colorSchemes.windows-10-light;
  # colorScheme = inputs.nix-colors.colorSchemes.windows-95;
  # colorScheme = inputs.nix-colors.colorSchemes.windows-95-light;
  # colorScheme = inputs.nix-colors.colorSchemes.windows-highcontrast;
  # colorScheme = inputs.nix-colors.colorSchemes.windows-highcontrast-light;
  # colorScheme = inputs.nix-colors.colorSchemes.windows-nt;
  # colorScheme = inputs.nix-colors.colorSchemes.windows-nt-light;
  # colorScheme = inputs.nix-colors.colorSchemes.woodland;
  # colorScheme = inputs.nix-colors.colorSchemes.xcode-dusk;
  # colorScheme = inputs.nix-colors.colorSchemes.zenbones;
  # colorScheme = inputs.nix-colors.colorSchemes.zenburn;
  

  home.file = {
    ".config/gh-dash/config.yml".source = ./gh-dash.yml;
    ".config/tig/config".text = ''
      # Use local timezone with custom date format
      set main-view-date = custom
      set main-view-date-format = "%Y-%m-%d %H:%M"
      set main-view-date-local = true
    '';
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
      neovim = inputs.neovim.packages."${pkgs.stdenv.hostPlatform.system}".default;
      flake-gen = inputs.flake-gen.packages."${pkgs.stdenv.hostPlatform.system}".default;
      jt = inputs.jt.packages."${pkgs.stdenv.hostPlatform.system}".default;
    })
  ];

  home.packages = with pkgs; [
    bandwhich
    bruno
    claude-code
    opencode
    codex
    delta
    difftastic
    dua
    eza
    fd
    flake-gen
    fzf
    gh
    diffnav
    imagemagick
    jt
    jujutsu
    lazydocker
    lazygit
    neovim
    ripgrep
    television
    qpdf
    aichat
    tig
  ];

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      dialect = "uk";
      update_check = false;
      search_mode = "fuzzy";
      style = "compact";
      inline_height = 10;
      show_help = false;
      exit_mode = "return-query";
    };
  };

  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
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
      diff = {
        tool = "vimdiff";
      };
      merge = {
        tool = "vimdiff";
      };
      difftool = {
        prompt = false;
      };
    };
  };

  # Never change
  home.stateVersion = "24.05";
}
