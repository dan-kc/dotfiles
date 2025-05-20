{
  pkgs,
  ...
}:
{
  home.file = {
    ".config/hypr/hyprland.conf".source = ./hyprland.conf;
    ".config/hypr/hyprpaper.conf".source = ./hyprpaper.conf;
  };
  home.packages = with pkgs; [
    hyprpaper
    hyprshot
    hyprsunset
  ];
}
