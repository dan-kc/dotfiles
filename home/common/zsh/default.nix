{
  pkgs,
  ...
}:
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
      v = "nvim";
      c = "clear";
      rm = "trash";
      ls = "exa";
    };

    initContent = ''
      # Bind atuin ctrl-r after zsh-vi-mode initializes
      zvm_after_init() {
        zvm_bindkey viins '^R' atuin-search
        zvm_bindkey vicmd '^R' atuin-search
      }

      # Disable ctrl-s
      stty stop undef

      # Export vars
      export SRC_ENDPOINT="https://sourcegraph.com"
      export EDITOR="nvim"
      export HYPRSHOT_DIR="/home/daniel/screenshots/"

      # Functions
      ff() { du -a | awk '{print $2}' | $(fzf --height 40% --border)| xargs -r $EDITOR ; }

      h() {
        history -n -100000 | tac | awk '!seen[$0]++' | fzf --height 40% --border | wl-copy
      }

      function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
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
