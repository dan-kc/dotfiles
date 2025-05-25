{
  pkgs,
  lib,
  ...
}:
{
  options.globalFonts.selectedFont = lib.mkOption {
    type = lib.types.str;
    default = "Hurmit Nerd Font Propo";
    description = "The name of the globally selected Nerd Font.";
  };

  config = {
    home.packages = with pkgs; [
      nerd-fonts.geist-mono
      nerd-fonts.hack # Hack Nerd Font Propo
      nerd-fonts.hurmit # Hurmit Nerd Font Propo
      nerd-fonts.monofur # Monofur Nerd Font Propo
      nerd-fonts.fira-code # FiraCode Nerd Font Propo
      nerd-fonts.agave # Agave Nerd Font Propo
      nerd-fonts.jetbrains-mono # JetBrainsMono Nerd Font Propo
    ];
  };

  # config.globalFonts.selectedFont = "FiraCode Nerd Font Propo";
}
