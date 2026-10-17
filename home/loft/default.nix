{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../base/colorscheme.nix
    ../base/fonts.nix
    ../base/starship.nix
    ../base/zsh
    ../base/yazi
    ../agents/pi
  ];

  home = {
    username = "daniel";
    homeDirectory = "/home/daniel";
    stateVersion = "26.05";
    packages = with pkgs; [
      codex
      herdr
      lazygit
      gh
      ripgrep
      fzf
    ];
  };

  # Also identify loft in local shells, tmux and Yazi's Starship header.
  programs.starship.settings.hostname.ssh_only = lib.mkForce false;
  programs.starship.settings.battery.disabled = true;

  # Shared Zsh binds Ctrl-R to Atuin and uses these shell integrations.
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      dialect = "uk";
      update_check = false;
      style = "compact";
      inline_height = 10;
    };
  };
  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.git = {
    enable = true;
    settings = {
      user.name = "Daniel Cox";
      user.email = "63171098+dan-kc@users.noreply.github.com";
      init.defaultBranch = "main";
    };
  };
  home.file.".config/theme.yaml".text =
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: value: ''${name}: "${value}"'') config.colorScheme.palette
    )
    + "\n";
}
