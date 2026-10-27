{
  pkgs,
}:

pkgs.stdenv.mkDerivation {
  pname = "launcher";
  version = "0.1.0";

  src = pkgs.writeShellScript "launcher-script" ''
    #!/bin/sh

    apps="alacritty\nghostty\nanki\ntodoist\nbruno\nslack\ndiscord\npostman\nthunderbird\npavucontrol\nobsidian\nobs\nvivaldi\nfiles\nt3code"

    # Use printf for better compatibility
    selected_app=$(printf "$apps" | fuzzel --dmenu -p "Launch Application: ")

    # Execute if a valid selection is made
    if [ -n "$selected_app" ]; then
        if [ "$selected_app" = "todoist" ]; then
            exec todoist-electron &
        elif [ "$selected_app" = "files" ]; then
            exec nautilus &
        elif [ "$selected_app" = "ghostty" ]; then
            exec ghostty +new-window &
        elif [ "$selected_app" = "t3code" ]; then
            exec t3code-desktop &
        else
            exec "$selected_app" &
        fi
    fi
  '';
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/launcher
    chmod +x $out/bin/launcher
  '';
}
