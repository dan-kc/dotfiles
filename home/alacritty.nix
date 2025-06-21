{
  pkgs,
  config,
  ...
}:
{
  home.file = {
    ".config/alacritty.toml".text = ''
      [general]
      import=["~/.config/alacritty/colors.toml"]

      [font]
      normal = { family = "${config.globalFonts.selectedFont}" } 
      builtin_box_drawing = false
      size = 16

      [window]
      padding = { x = 20, y = 20 }
      dynamic_padding = true
      opacity = 1.0

      [selection]
      save_to_clipboard = true

      [keyboard]
      bindings = [
        {key = "Plus", mods = "Control|Shift", action = "IncreaseFontSize"} # QMK inputs "Control|Shift Equals" when you try to "Control Plus". For some reason this fixes it.
      ]
    '';

  };
  home.packages = [
    pkgs.alacritty
  ];
}
