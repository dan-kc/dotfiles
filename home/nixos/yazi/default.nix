{
  pkgs,
  inputs,
  ...
}:
{
  programs.yazi = {
    enable = true;
    package = inputs.yazi.packages."${pkgs.system}".default;
    plugins = {
      wl-clipboard = pkgs.yaziPlugins.wl-clipboard;
      git = pkgs.yaziPlugins.git;
      starship = pkgs.yaziPlugins.starship;
    };
  };
}
