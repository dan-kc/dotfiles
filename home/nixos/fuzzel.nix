{
  pkgs,
  config,
  ...
}:
{
  home.file = {
    ".config/fuzzel/fuzzel.ini" = {
      text = ''
        [main]
        font=${config.globalFonts.selectedFont}

        [colors]
        background=${config.colorScheme.palette.base00}ff
        text=${config.colorScheme.palette.base05}ff
        border=${config.colorScheme.palette.base0C}ff

        [border]
        width=2
      '';
    };
  };
  home.packages = with pkgs; [
    fuzzel
  ];
}
