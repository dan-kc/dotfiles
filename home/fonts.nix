{ pkgs, ... }:
let
  myNerdFonts = pkgs.nerdfonts.override {
    fonts = [
      "GeistMono"
      "Hack"
###      "BlexMono"
  #    "Hasklug"
      "Monofur"
  #    "Hurmit"
      "FiraCode"
      "Agave"
      "JetBrainsMono"
    ];
  };
in
{
  home.packages = [ myNerdFonts ];
}
