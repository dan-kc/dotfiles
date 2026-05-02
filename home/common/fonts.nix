{
  pkgs,
  lib,
  config,
  ...
}:
let
  # Change this one value when you want to switch fonts.
  defaultFont = "ubuntu-mono";

  fontCatalog = {
    # key = exact family name used by apps
    fira-code = {
      package = pkgs.nerd-fonts.fira-code;
      family = "FiraCode Nerd Font Mono";
    };
    hurmit = {
      package = pkgs.nerd-fonts.hurmit;
      family = "Hurmit Nerd Font Mono";
    };
    jetbrains-mono = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      family = "JetBrainsMono Nerd Font Mono";
    };
    martian-mono = {
      package = pkgs.nerd-fonts.martian-mono;
      family = "MartianMono Nerd Font Mono";
    };
    monaspace = {
      package = pkgs.monaspace;
      family = "Monaspace Neon NF";
    };
    monaspace-argon = {
      package = pkgs.monaspace;
      family = "Monaspace Argon NF";
    };
    monaspace-krypton = {
      package = pkgs.monaspace;
      family = "Monaspace Krypton NF";
    };
    monaspace-radon = {
      package = pkgs.monaspace;
      family = "Monaspace Radon NF";
    };
    monaspace-xenon = {
      package = pkgs.monaspace;
      family = "Monaspace Xenon NF";
    };
    monofur = {
      package = pkgs.nerd-fonts.monofur;
      family = "Monofur Nerd Font Mono";
    };
    profont = {
      package = pkgs.profont;
      family = "ProFont";
    };
    proggy-clean = {
      package = pkgs.proggyfonts;
      family = "ProggyCleanTT";
    };
    proggy-small = {
      package = pkgs.proggyfonts;
      family = "ProggySmallTT";
    };
    proggy-square = {
      package = pkgs.proggyfonts;
      family = "ProggySquareTT";
    };
    proggy-tiny = {
      package = pkgs.proggyfonts;
      family = "ProggyTinyTT";
    };
    space-mono = {
      package = pkgs.google-fonts;
      family = "Space Mono";
    };
    ubuntu-mono = {
      package = pkgs.nerd-fonts.ubuntu-mono;
      family = "UbuntuMono Nerd Font Mono";
    };
  };

  selectedFont = fontCatalog.${config.globalFonts.default};
in
{
  options.globalFonts = {
    default = lib.mkOption {
      type = lib.types.enum (builtins.attrNames fontCatalog);
      default = defaultFont;
      example = "martian-mono";
      description = "Font preset to use globally. Change defaultFont in this file.";
    };

    selectedFont = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      description = "Resolved font family name used by applications.";
    };
  };

  config = {
    globalFonts.selectedFont = selectedFont.family;

    home.packages = [
      selectedFont.package
    ];
  };
}
