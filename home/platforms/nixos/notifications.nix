{
  pkgs,
  config,
  ...
}:
{
  home.file = {
    ".config/mako/config" = {
      text = ''
        max-history=4
        font=${config.globalFonts.selectedFont}
        background-color=#${config.colorScheme.palette.base00}
        text-color=#${config.colorScheme.palette.base05}
        height=140
        width=520
        margin=6
        padding=4
        border-size=2
        border-color=#${config.colorScheme.palette.base03}
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
