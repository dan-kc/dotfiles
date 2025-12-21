{
  pkgs,
  config,
  ...
}:
{
  home.file = {
    ".config/mako/config".text = ''
      font=${config.globalFonts.selectedFont}

    '';

  };
  home.packages = with pkgs; [
    libnotify
    mako
  ];
}
