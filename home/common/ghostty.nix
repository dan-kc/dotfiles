{
  config,
  pkgs,
  ...
}:
{
  programs.ghostty = {
    enable = true;
    package = if pkgs.stdenv.hostPlatform.isDarwin then null else pkgs.ghostty;

    settings = {
      font-family = config.globalFonts.selectedFont;
      theme = "nix-colors";
      window-padding-x = 20;
      window-padding-y = 20;
    };

    themes.nix-colors = {
      background = config.colorScheme.palette.base00;
      foreground = config.colorScheme.palette.base05;
      cursor-color = config.colorScheme.palette.base05;
      cursor-text = config.colorScheme.palette.base00;
      selection-background = config.colorScheme.palette.base02;
      selection-foreground = config.colorScheme.palette.base05;

      palette = [
        "0=#${config.colorScheme.palette.base00}"
        "1=#${config.colorScheme.palette.base08}"
        "2=#${config.colorScheme.palette.base0B}"
        "3=#${config.colorScheme.palette.base0A}"
        "4=#${config.colorScheme.palette.base0D}"
        "5=#${config.colorScheme.palette.base0E}"
        "6=#${config.colorScheme.palette.base0C}"
        "7=#${config.colorScheme.palette.base05}"
        "8=#${config.colorScheme.palette.base03}"
        "9=#${config.colorScheme.palette.base09}"
        "10=#${config.colorScheme.palette.base01}"
        "11=#${config.colorScheme.palette.base02}"
        "12=#${config.colorScheme.palette.base04}"
        "13=#${config.colorScheme.palette.base06}"
        "14=#${config.colorScheme.palette.base0F}"
        "15=#${config.colorScheme.palette.base07}"
      ];
    };
  };
}
