{
  pkgs,
}:

pkgs.stdenv.mkDerivation {
  pname = "theme-switch";
  version = "0.1.0";

  src = pkgs.writeShellScript "theme-switch-script" ''
    #!/bin/sh

    # Randomly pick a flie in /wallpapers
    selected_file=$(find ~/wallpapers/dark ~/wallpapers/light -type f -print0 | shuf -z -n 1 | xargs -0)

    ${pkgs.flavours}/bin/flavours generate dark "$selected_file"
    ${pkgs.flavours}/bin/flavours apply generated

    hyprctl hyprpaper reload ,"$selected_file"

    # cat <<EOF > ~/.config/hypr/hyprpaper.conf
    # preload = $selected_file
    # wallpaper = , $selected_file
    # EOF
  '';
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/theme-switch
    chmod +x $out/bin/theme-switch
  '';
}
