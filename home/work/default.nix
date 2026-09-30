{
  ...
}:
{
  # The work machine owns its existing .zshenv outside Home Manager.
  home.file."./.zshenv".enable = false;
}
