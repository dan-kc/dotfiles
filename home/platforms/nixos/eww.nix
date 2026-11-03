{
  config,
  pkgs,
  lib,
  ...
}:
let
  configDir = "${config.xdg.configHome}/eww";
  statusData = pkgs.writeShellApplication {
    name = "status-data";
    runtimeInputs = [
      pkgs.python3
      pkgs.wireplumber
      pkgs.tailscale
    ];
    text = ''
      exec python3 ${./eww/status.py} "$@"
    '';
  };
  statusToggle = pkgs.writeShellApplication {
    name = "status-toggle";
    text = ''
      exec ${pkgs.eww}/bin/eww --config ${lib.escapeShellArg configDir} open --toggle status
    '';
  };
in
{
  # Keep the old command working for scripts that used the notification toggle.
  home.packages = [
    pkgs.eww
    statusToggle
    (pkgs.writeShellScriptBin "status-notify" ''
      exec ${statusToggle}/bin/status-toggle "$@"
    '')
  ];

  xdg.configFile."eww/eww.yuck".text =
    builtins.replaceStrings
      [
        "@statusData@"
        "@eww@"
        "@configDir@"
        "@niri@"
      ]
      [
        "${statusData}/bin/status-data"
        "${pkgs.eww}/bin/eww"
        (lib.escapeShellArg configDir)
        "${pkgs.niri}/bin/niri"
      ]
      (builtins.readFile ./eww/eww.yuck);

  xdg.configFile."eww/eww.scss".text = ''
    $background: #${config.colorScheme.palette.base00};
    $surface: #${config.colorScheme.palette.base01};
    $border: #${config.colorScheme.palette.base03};
    $muted: #${config.colorScheme.palette.base04};
    $text: #${config.colorScheme.palette.base05};
    $accent: #${config.colorScheme.palette.base0D};
    $green: #${config.colorScheme.palette.base0B};
    $red: #${config.colorScheme.palette.base08};
  '' + builtins.readFile ./eww/eww.scss + ''
    * { font-family: "${config.globalFonts.selectedFont}"; }
  '';
}
