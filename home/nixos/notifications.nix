{
  pkgs,
  inputs,
  config,
  ...
}:
let
  hexToRGBString = inputs.nix-colors.lib-core.conversions.hexToRGBString;
in
{
  home.file = {
    ".config/mako/config".text = ''
      max-history=4
      font=${config.globalFonts.selectedFont}
      background-color=#${config.colorScheme.palette.base00}
      text-color=#${config.colorScheme.palette.base05}
      height=140
      width=320
      margin=14
      padding=4
      border-size=2
      border-color=#${config.colorScheme.palette.base0C}
      anchor=top-left
      '';

  };
  home.packages = with pkgs; [
    libnotify
    mako
  ];
}
