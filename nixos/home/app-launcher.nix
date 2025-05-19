{
  pkgs,
}:

pkgs.stdenv.mkDerivation {
  pname = "launcher";
  version = "0.1.0";

  src = pkgs.writeShellScript "launcher-script" ''
    #!/bin/sh

    apps="vivaldi\nslack\nwezterm\nanki\ndiscord\npostman\nthunderbird\nvlc\nzen\nalacritty"

    # Use printf for better compatibility
    selected_app=$(printf "$apps" | bemenu -i -p "Launch Application:")

    # Execute if a valid selection is made
    if [ -n "$selected_app" ]; then
        $selected_app &
    fi
  '';
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/launcher
    chmod +x $out/bin/launcher
  '';
}
