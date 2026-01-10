{
  pkgs,
  config,
  ...
}:
{
  home.file = {
    ".config/alacritty.toml".text = ''
      [colors]
      draw_bold_text_with_bright_colors = false

      # Default colors
      [colors.primary]
      background = '#${config.colorScheme.palette.base00}'
      foreground = '#${config.colorScheme.palette.base05}'

      # Colors the cursor will use if `custom_cursor_colors` is true
      [colors.cursor]
      text = '#${config.colorScheme.palette.base00}'
      cursor = '#${config.colorScheme.palette.base05}'

      # Normal colors
      [colors.normal]
      black = '#${config.colorScheme.palette.base00}'
      red = '#${config.colorScheme.palette.base08}'
      green = '#${config.colorScheme.palette.base0B}'
      yellow = '#${config.colorScheme.palette.base0A}'
      blue = '#${config.colorScheme.palette.base0D}'
      magenta = '#${config.colorScheme.palette.base0E}'
      cyan = '#${config.colorScheme.palette.base0C}'
      white = '#${config.colorScheme.palette.base05}'

      # Bright colors
      [colors.bright]
      black = '#${config.colorScheme.palette.base03}'
      red = '#${config.colorScheme.palette.base09}'
      green = '#${config.colorScheme.palette.base01}'
      yellow = '#${config.colorScheme.palette.base02}'
      blue = '#${config.colorScheme.palette.base04}'
      magenta = '#${config.colorScheme.palette.base06}'
      cyan = '#${config.colorScheme.palette.base0F}'
      white = '#${config.colorScheme.palette.base07}'

      [font]
      normal = { family = "${config.globalFonts.selectedFont}" } 
      builtin_box_drawing = false
      size = 12

      [scrolling]
      multiplier = 1

      [window]
      padding = { x = 20, y = 20 }
      dynamic_padding = true
      decorations = "None"
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
