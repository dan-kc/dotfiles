{
  inputs,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./colorscheme.nix
    ./fonts.nix
    ./ghostty.nix
    ./starship.nix
    ./yazi
    ./zsh
  ];

  home.file = {
    # Skills available to every agent (pi and codex both read ~/.agents/skills).
    # ".agents/skills/pair-programmer".source = ./skills/pair-programmer;
    ".agents/skills/bro".source = ./skills/pstack/bro;

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
  }
  // (
    let
      skills = builtins.readDir ./skills/pstack;
    in
    builtins.listToAttrs (
      builtins.map
        (name: {
          name = ".pi/agent/skills/${name}";
          value.source = ./skills/pstack + "/${name}";
        })
        (
          builtins.filter (
            name:
            skills.${name} == "directory"
            && builtins.elem name [
              "bro"
            ]
          ) (builtins.attrNames skills)
        )
    )
  );

  nixpkgs.overlays = [
    (final: prev: {
      neovim = inputs.neovim.packages."${pkgs.stdenv.hostPlatform.system}".default;
      jt = inputs.jt.packages."${pkgs.stdenv.hostPlatform.system}".default;
    })
  ];

  home.packages = with pkgs; [
    fzf
    gh
    jt
    neovim
    ripgrep
    lazygit
  ];

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [ "--disable-up-arrow" ];
    themes."nix-colors" = {
      theme = {
        name = "nix-colors";
        parent = "default";
      };
      colors.SyntaxCommand = "@white";
    };
    settings = {
      dialect = "uk";
      update_check = false;
      search_mode = "fuzzy";
      style = "compact";
      inline_height = 10;
      show_help = false;
      exit_mode = "return-query";
      keys.scroll_exits = false;
      search.filters = [
        "global"
        "directory"
      ];
      theme.name = "nix-colors";
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

  programs.diff-so-fancy = {
    enable = true;
    enableGitIntegration = true;
    settings = {
      markEmptyLines = true;
    };
  };

  # Never change
  home.stateVersion = "24.05";
}
