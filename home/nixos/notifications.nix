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
    ".config/mako/config" = {
      text = ''
        max-history=4
        font=${config.globalFonts.selectedFont}
        background-color=#${config.colorScheme.palette.base00}
        text-color=#${config.colorScheme.palette.base05}
        height=140
        width=320
        margin=12
        padding=4
        border-size=4
        border-color=#${config.colorScheme.palette.base0C}
        anchor=top-left
      '';
      onChange = "${pkgs.mako}/bin/makoctl reload || true";
    };
  };
  home.packages = with pkgs; [
    libnotify
    mako
  ];
}
