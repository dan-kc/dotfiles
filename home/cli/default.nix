{ pkgs, ... }:
let
  google-cloud-with-plugins = pkgs.google-cloud-sdk.withExtraComponents (
    with pkgs.google-cloud-sdk.components;
    [
      gke-gcloud-auth-plugin
    ]
  );
in

{
  home.file = {
    ".zshrc".source = ./zsh/.zshrc;
    "zsh_modules".source = ./zsh/zsh_modules;
    ".config/starship.toml".source = ./starship.toml;
    ".config/yazi".source = ./yazi;
    ".config/lazygit/config.yml".source = ./lazygit.yml;
    ".config/atuin/config.toml".source = ./atuin.toml;
  };

  home.packages = with pkgs; [
    atuin
    yazi
    zsh
    tree
    fzf
    lazygit
    lazydocker
    eza
    fd
    ripgrep
    zoxide
    starship
    trash-cli
    k3s
    gh
    fnm
    cargo
    rustc
    gcc
    bandwhich
    dua
    jq
    just
    miniserve
    rsync
    src-cli
    opentofu
    packer
    unzip
    git-open
    ripdrag
    # ragenix
    difftastic
    pass
    gnupg # Currently only use for pass, which i only use for gpg, which I only use for vault.
    hyprshot
    google-cloud-with-plugins
    hurl
  ];

  programs.git = {
    enable = true;
    userName = "Daniel Cox";
    userEmail = "daniel@keone.dev";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };
}
