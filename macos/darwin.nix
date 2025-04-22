{
  config,
  pkgs,
  inputs,
  ...
}:
{
  nixpkgs.overlays = [
    (final: prev: {
      home-manager = inputs.home-manager.packages."${pkgs.system}".default;
    })
  ];
  environment.systemPackages = [
    pkgs.home-manager
    pkgs.vim
    pkgs.home-manager
  ];
  # environment.darwinConfig
  # Necessary for using flakes on this system.
  nix.enable = false; # I think I need this only because we installed via determinate.
  nix.package = pkgs.nix;
  nix.settings.experimental-features = "nix-command flakes";

  programs.zsh.enable = true;
  # Used for backwards compatibility. please read the changelog
  # before changing: `darwin-rebuild changelog`.
  system.stateVersion = 4;

  # system.configurationRevision = self.rev or self.dirtyRev or null;

  homebrew = {
    enable = true;
    casks = [
      "raycast"
    ];
  };

  system.defaults = {
    dock = {
      autohide = true;
      show-process-indicators = false;
      show-recents = false;
      static-only = true;
    };
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
    };
  };

  # Declare the user that will be running `nix-darwin`.
  users.users.daniel = {
    name = "daniel";
    home = "/Users/daniel";
  };
  # Create /etc/zshrc that loads the nix-darwin environment.
}
