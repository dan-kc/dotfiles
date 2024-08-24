{ pkgs, ... }:

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
    git
    just
    miniserve
    rsync
    src-cli
  ];
}
