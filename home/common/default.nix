{
  inputs,
  pkgs,
  config,
  ...
}:
{
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./fonts.nix
    ./ghostty.nix
    ./starship.nix
    ./yazi
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
  # colorScheme = inputs.nix-colors.colorSchemes.materia; # 7/10
  # colorScheme = inputs.nix-colors.colorSchemes.material; # 7/10
  # colorScheme = inputs.nix-colors.colorSchemes.material-darker; # 7/10
  # colorScheme = inputs.nix-colors.colorSchemes.material-palenight; # 8/10 quite blue/gray
  # colorScheme = inputs.nix-colors.colorSchemes.mellow-purple; # 7/10 very very very purple
  # colorScheme = inputs.nix-colors.colorSchemes.monokai;
  # colorScheme = inputs.nix-colors.colorSchemes.nebula; # 7/10 Very blue
  # colorScheme = inputs.nix-colors.colorSchemes.nord; # 7/10
  # colorScheme = inputs.nix-colors.colorSchemes.nova; # 8/10
  # colorScheme = inputs.nix-colors.colorSchemes.oceanicnext # 8/10;
  # colorScheme = inputs.nix-colors.colorSchemes.one-light;
  # colorScheme = inputs.nix-colors.colorSchemes.onedark; # 8/10;
  # colorScheme = inputs.nix-colors.colorSchemes.paraiso; # 8/10;
  # colorScheme = inputs.nix-colors.colorSchemes.pasque; # 7/10
  # colorScheme = inputs.nix-colors.colorSchemes.phd; # 7/10
  # colorScheme = inputs.nix-colors.colorSchemes.pinky; # 8/10 really nice but too dark bg
  # colorScheme = inputs.nix-colors.colorSchemes.porple; # 7/10
  # colorScheme = inputs.nix-colors.colorSchemes.primer-dark-dimmed; # 7/10
  # colorScheme = inputs.nix-colors.colorSchemes.railscasts;
  # colorScheme = inputs.nix-colors.colorSchemes.rebecca; # 6.5 Intensely blue/violet
  colorScheme = inputs.nix-colors.colorSchemes.rose-pine;
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
    ".pi/agent/themes/nix-colors.json".text = builtins.toJSON {
      "$schema" =
        "https://raw.githubusercontent.com/earendil-works/pi/main/packages/coding-agent/src/modes/interactive/theme/theme-schema.json";
      name = "nix-colors";
      vars = builtins.mapAttrs (_: color: "#${color}") config.colorScheme.palette;
      colors = {
        accent = "base0D";
        border = "base03";
        borderAccent = "base0D";
        borderMuted = "base02";
        success = "base0B";
        error = "base08";
        warning = "base0A";
        muted = "base04";
        dim = "base03";
        text = "";
        thinkingText = "base04";
        scrollbarTrack = "base02";
        scrollbarThumb = "base04";

        selectedBg = "base02";
        searchMatchBg = "base0A";
        searchMatchText = "base00";
        userMessageBg = "base01";
        userMessageText = "base05";
        customMessageBg = "base01";
        customMessageText = "base05";
        customMessageLabel = "base0E";
        toolPendingBg = "base01";
        toolSuccessBg = "base01";
        toolErrorBg = "base01";
        toolTitle = "base0D";
        toolOutput = "";

        mdHeading = "base0A";
        mdLink = "base0D";
        mdLinkUrl = "base04";
        mdCode = "base0C";
        mdCodeBlock = "";
        mdCodeBlockBorder = "base03";
        mdQuote = "base04";
        mdQuoteBorder = "base03";
        mdHr = "base03";
        mdListBullet = "base0C";

        toolDiffAdded = "base0B";
        toolDiffRemoved = "base08";
        toolDiffContext = "base04";

        syntaxComment = "base03";
        syntaxKeyword = "base0E";
        syntaxFunction = "base0D";
        syntaxVariable = "base08";
        syntaxString = "base0B";
        syntaxNumber = "base09";
        syntaxType = "base0A";
        syntaxOperator = "base0C";
        syntaxPunctuation = "base05";

        thinkingOff = "base03";
        thinkingMinimal = "base04";
        thinkingLow = "base0D";
        thinkingMedium = "base0C";
        thinkingHigh = "base0E";
        thinkingXhigh = "base09";
        thinkingMax = "base08";
        bashMode = "base0A";
      };
      export = {
        pageBg = "base00";
        cardBg = "base01";
        infoBg = "base02";
      };
    };

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

  programs.pi-coding-agent = {
    enable = true;
    settings = {
      defaultProvider = "openai-codex";
      defaultModel = "gpt-5.6-sol";
      defaultThinkingLevel = "high";
      theme = "nix-colors";
      lastChangelogVersion = pkgs.pi-coding-agent.version;
    };
    context = ''
      ## Pi configuration

      Pi configuration is managed declaratively by Home Manager in
      /home/daniel/dotfiles/home/common/default.nix.
      Make persistent Pi configuration changes in that Nix configuration,
      including changes to these global instructions. Do not edit or replace
      generated configuration files under ~/.pi/agent or use Pi commands to
      persist settings. Apply changes through the normal Home Manager workflow.
      Session-only model and thinking changes are fine. Credentials, sessions,
      caches, and trust state remain writable and are not managed in Nix;
      never put credentials in the Nix store.
    '';
  };

  nixpkgs.overlays = [
    (final: prev: {
      neovim = inputs.neovim.packages."${pkgs.stdenv.hostPlatform.system}".default;
      flake-gen = inputs.flake-gen.packages."${pkgs.stdenv.hostPlatform.system}".default;
      jt = inputs.jt.packages."${pkgs.stdenv.hostPlatform.system}".default;
      pi-coding-agent = prev.pi-coding-agent.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          pi_bundle="$out/lib/node_modules/pi-monorepo/dist/bundle"
          command_file=$(grep -R -l 'name:"quit",description:`Quit ' "$pi_bundle" | head -n1)

          substituteInPlace "$command_file" \
            --replace-fail '{name:"quit",description:`Quit ''${APP_NAME}`}' \
                           '{name:"quit",description:`Quit ''${APP_NAME}`},{name:"exit",description:`Quit ''${APP_NAME}`}' \
            --replace-fail 'if(text==="/quit"){this.editor.setText(""),await this.shutdown();return}' \
                           'if(text==="/quit"||text==="/exit"){this.editor.setText(""),await this.shutdown();return}'
        '';
      });
    })
  ];

  home.packages = with pkgs; [
    codex
    flake-gen
    fzf
    gh
    jt
    neovim
    ripgrep
    lazydocker
    lazygit
    imagemagick
    qpdf
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
