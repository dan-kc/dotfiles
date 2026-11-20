{ lib, pkgs, ... }:
{
  programs.zsh.initContent = lib.mkOrder 500 (lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
    # Set a supported type before ZLE and plugins read terminal capabilities.
    if [[ -n "$SSH_CONNECTION" && -n "$TERM" && "$TERM" != dumb ]] &&
      ! /usr/bin/infocmp "$TERM" >/dev/null 2>&1; then
      export TERM=xterm-256color
    fi
  '');
}
