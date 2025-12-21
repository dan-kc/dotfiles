{
  ...
}:
# zsh is a system bin already so we don't specify the package here
{
  home.file = {
    ".zshrc".source = ./zshrc;
    "zsh_modules".source = ./zsh_modules;
  };
}
