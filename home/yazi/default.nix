{
  pkgs,
  inputs,
  ...
}:
{
  home.file = {
    ".config/yazi/yazi.toml".source = ./yazi.toml;
    ".config/yazi/keymap.toml".source = ./keymap.toml;
    ".config/yazi/init.lua".source = ./init.lua;
  };
  programs.yazi = {
    package = inputs.yazi.packages."${pkgs.system}".default;
    enable = true;
    plugins = {
      git = pkgs.yaziPlugins.git;
      starship = pkgs.yaziPlugins.starship;
    };
  };
}
