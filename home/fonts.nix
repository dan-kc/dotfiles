{ pkgs, ... }:
let
  myNerdFonts = pkgs.nerdfonts.override {
    fonts = [
      "GeistMono"
      "Hack"
      "Monofur"
      # "Hurmit" # Doesn't work
      "FiraCode"
      "Agave"
      "JetBrainsMono"
    ];
  };
in
{
  home.packages = [ myNerdFonts ];
}
