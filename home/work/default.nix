{
  lib,
  ...
}:
{
  # The work machine owns its existing .zshenv outside Home Manager.
  home.file."./.zshenv".enable = false;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "claude-code" ];

  programs.claude-code.enable = true;
}
