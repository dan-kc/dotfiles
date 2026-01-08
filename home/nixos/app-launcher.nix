{
  pkgs,
}:

pkgs.stdenv.mkDerivation {
  pname = "launcher";
  version = "0.1.0";

  src = pkgs.writeShellScript "launcher-script" ''
    #!/bin/sh

    apps="alacritty\nanki\nbruno\nslack\ndiscord\npostman\nthunderbird\npavucontrol\nobsidian\nzen\nobs\nvivaldi"

    # Use printf for better compatibility
    selected_app=$(printf "$apps" | fuzzel --dmenu -p "Launch Application: ")

    # Execute if a valid selection is made
    if [ -n "$selected_app" ]; then
        if [ "$selected_app" = "zen" ]; then
            exec zen-twilight -P default &
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
