{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nerd-fonts.geist-mono
    nerd-fonts.hack
    nerd-fonts.monofur
    nerd-fonts.fira-code
    nerd-fonts.agave
    nerd-fonts.jetbrains-mono
  ];
}
