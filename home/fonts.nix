{
  pkgs,
  lib,
  ...
}:
{
  options.globalFonts.selectedFont = lib.mkOption {
    type = lib.types.str;
    default = "Hurmit Nerd Font Mono";
    description = "The name of the globally selected Nerd Font.";
  };

  # List all installed fonts
  # fc-list : file family style | grep -E "Mono"
  config = {
    home.packages = with pkgs; [
      nerd-fonts.jetbrains-mono # JetBrainsMono Nerd Font Mono 7/10
      proggyfonts
      nerd-fonts.geist-mono # GeistMono Nerd Font Mono
      nerd-fonts.hack # Hack Nerd Font Mono
      nerd-fonts.hurmit # Hurmit Nerd Font Propo
      nerd-fonts.monofur # Monofur Nerd Font Propo
      nerd-fonts.fira-code # FiraCode Nerd Font Propo
      nerd-fonts.agave # Agave Nerd Font Propo 5/10
      nerd-fonts.space-mono # SpaceMono Nerd Font Propo
      nerd-fonts.mononoki # Mononoki Nerd Font Propo
    ];
  };
}
