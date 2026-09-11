{
  inputs,
  pkgs,
  ...
}:
let
  neovim = inputs.neovim.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = false;
    enableCompletion = false;

    history = {
      size = 100000;
      save = 100000;
      ignoreDups = true;
    };

    shellAliases = {
      v = "${neovim}/bin/nvim";
      rm = "${pkgs.trash-cli}/bin/trash";
      ls = "${pkgs.eza}/bin/eza";
    };

    initContent = ''
      # Bind atuin ctrl-r after zsh-vi-mode initializes
      zvm_after_init() {
        zvm_bindkey viins '^R' atuin-search
        zvm_bindkey vicmd '^R' atuin-search
      }

      # Disable ctrl-s
      ${pkgs.coreutils}/bin/stty stop undef

      # Export vars
      export EDITOR="${neovim}/bin/nvim"
      if [ -r /run/secrets/cloudflare_api_key ]; then
        export CLOUDFLARE_API_TOKEN="$(${pkgs.coreutils}/bin/cat /run/secrets/cloudflare_api_key)"
      fi

      # Functions
      ff() {
        ${pkgs.coreutils}/bin/du -a |
          ${pkgs.gawk}/bin/awk '{print $2}' |
          ${pkgs.fzf}/bin/fzf --height 40% --border |
          ${pkgs.findutils}/bin/xargs -r "$EDITOR"
      }

      h() {
        local clipboard_command="${
          if pkgs.stdenv.isDarwin then "$HOME/.local/bin/pbcopy" else "${pkgs.wl-clipboard}/bin/wl-copy"
        }"
        local selected

        selected=$(history -n -100000 |
          ${pkgs.coreutils}/bin/tac |
          ${pkgs.gawk}/bin/awk '!seen[$0]++' |
          ${pkgs.fzf}/bin/fzf --height 40% --border) || return
        printf '%s' "$selected" | "$clipboard_command"
      }

      function y() {
        local tmp="$(${pkgs.coreutils}/bin/mktemp -t "yazi-cwd.XXXXXX")"
        ${pkgs.yazi}/bin/yazi "$@" --cwd-file="$tmp"
        if cwd="$(${pkgs.coreutils}/bin/cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          builtin cd -- "$cwd"
        fi
        ${pkgs.coreutils}/bin/rm -f -- "$tmp"
      }
    '';

    plugins = [
      {
        name = "zsh-vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];
  };
}
