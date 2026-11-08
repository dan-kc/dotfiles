{
  ...
}:
{
  imports = [
    ./lgtm.nix
    ./simulator.nix
    ./ssh-clipboard.nix
  ];

  # Keep the standalone switch command available on Macs.
  programs.home-manager.enable = true;

  home.file = {
    "Library/Application\ Support/lazygit/config.yml".source = ../../base/lazygit.yml;
    ".zprofile".source = ./zprofile;
  };
}
