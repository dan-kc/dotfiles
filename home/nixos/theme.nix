{
  pkgs,
}:

pkgs.stdenv.mkDerivation {
  pname = "theme-switch";
  version = "0.1.0";

  src = pkgs.writeShellScript "theme-switch-script" ''
    #!/bin/sh

    wallpaper_base_dir="$HOME/wallpapers"

    # Randomly pick a flie in wallpapers dir
    selected_file=$(find "$wallpaper_base_dir"/dark "$wallpaper_base_dir"/light -type f -print0 | shuf -z -n 1 | xargs -0)

    # Check if an argument (absolute path) is provided
    if [ "$#" -ge 1 ]; then
      # Use the provided argument as the selected file
      selected_file="$1"

      if [ ! -f "$selected_file" ]; then
        echo "Error: Provided path "$selected_file" is not a valid file."
        exit 1
      fi
    fi

    theme="light"
    if echo "$selected_file" | grep -q "$wallpaper_base_dir"/dark; then
      echo "$selected_file"
      theme="dark"
    fi

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
