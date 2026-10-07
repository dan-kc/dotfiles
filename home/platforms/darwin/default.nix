{
  ...
}:
{
  home.file = {
    "Library/Application\ Support/lazygit/config.yml".source = ../../base/lazygit.yml;
    ".zprofile".source = ./zprofile;
  };

  nixpkgs.overlays = [
    (_final: prev: {
      # direnv 2.37.1 can hang in upstream shell tests during checkPhase on Darwin.
      direnv = prev.direnv.overrideAttrs (_: {
        doCheck = false;
      });
    })
  ];

  # Allow home-manager to manage home-manager.
  programs.home-manager.enable = true;
}
