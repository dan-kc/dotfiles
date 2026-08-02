{
  config,
  pkgs,
  ...
}:
{
  programs.ghostty = {
    enable = true;
    package = if pkgs.stdenv.hostPlatform.isDarwin then null else pkgs.ghostty;
    systemd.enable = pkgs.stdenv.hostPlatform.isLinux;

    settings = {
      font-family = config.globalFonts.selectedFont;
      theme = "nix-colors";
      window-padding-x = 20;
      window-padding-y = 20;
      confirm-close-surface = false;
      quit-after-last-window-closed = true;

      keybind =
        if pkgs.stdenv.hostPlatform.isDarwin then
          [
            # Keep only the native new-tab and close-tab bindings.
            "super+t=new_tab"
            "super+w=close_tab:this"

            # Disable all other tab bindings.
            "super+alt+w=unbind"
            "super+shift+[=unbind"
            "super+shift+]=unbind"
            "super+digit_1=unbind"
            "super+1=unbind"
            "super+digit_2=unbind"
            "super+2=unbind"
            "super+digit_3=unbind"
            "super+3=unbind"
            "super+digit_4=unbind"
            "super+4=unbind"
            "super+digit_5=unbind"
            "super+5=unbind"
            "super+digit_6=unbind"
            "super+6=unbind"
            "super+digit_7=unbind"
            "super+7=unbind"
            "super+digit_8=unbind"
            "super+8=unbind"
            "super+9=unbind"

            # Disable splits/panes.
            "super+d=unbind"
            "super+shift+d=unbind"
            "super+[=unbind"
            "super+]=unbind"
            "super+alt+arrow_up=unbind"
            "super+alt+arrow_down=unbind"
            "super+alt+arrow_left=unbind"
            "super+alt+arrow_right=unbind"
            "super+ctrl+arrow_up=unbind"
            "super+ctrl+arrow_down=unbind"
            "super+ctrl+arrow_left=unbind"
            "super+ctrl+arrow_right=unbind"
            "super+ctrl+==unbind"
            "super+shift+enter=unbind"
          ]
        else
          [
            # Disable tabs.
            "ctrl+shift+tab=unbind"
            "ctrl+tab=unbind"
            "ctrl+shift+w=unbind"
            "ctrl+shift+t=unbind"
            "ctrl+shift+arrow_left=unbind"
            "ctrl+shift+arrow_right=unbind"
            "ctrl+page_up=unbind"
            "ctrl+page_down=unbind"
            "alt+digit_1=unbind"
            "alt+1=unbind"
            "alt+digit_2=unbind"
            "alt+2=unbind"
            "alt+digit_3=unbind"
            "alt+3=unbind"
            "alt+digit_4=unbind"
            "alt+4=unbind"
            "alt+digit_5=unbind"
            "alt+5=unbind"
            "alt+digit_6=unbind"
            "alt+6=unbind"
            "alt+digit_7=unbind"
            "alt+7=unbind"
            "alt+digit_8=unbind"
            "alt+8=unbind"
            "alt+9=unbind"

            # Disable splits/panes.
            "ctrl+shift+o=unbind"
            "ctrl+shift+e=unbind"
            "super+ctrl+[=unbind"
            "super+ctrl+]=unbind"
            "ctrl+alt+arrow_up=unbind"
            "ctrl+alt+arrow_down=unbind"
            "ctrl+alt+arrow_left=unbind"
            "ctrl+alt+arrow_right=unbind"
            "super+ctrl+shift+arrow_up=unbind"
            "super+ctrl+shift+arrow_down=unbind"
            "super+ctrl+shift+arrow_left=unbind"
            "super+ctrl+shift+arrow_right=unbind"
            "ctrl+shift+enter=unbind"
          ];
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
