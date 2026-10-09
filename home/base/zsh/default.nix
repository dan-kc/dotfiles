{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
let
  neovim = inputs.neovim.packages.${pkgs.stdenv.hostPlatform.system}.default;
  cfg = config.local.agent;
  agent = cfg.command;
in
{
  options.local.agent = {
    command = lib.mkOption {
      type = lib.types.str;
      default = "codex";
      description = "Coding agent CLI that ctrl-y sends the current command line to.";
    };
    resumeArgs = lib.mkOption {
      type = lib.types.str;
      default = "resume --last";
      description = "Arguments that resume the coding agent's most recent session, aliased to c.";
    };
  };

  config.programs.zsh = {
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
      c = "${agent} ${cfg.resumeArgs}";
    };

    initContent = ''
      # Send the current command line to the coding agent as a prompt
      agent-prompt() {
        [[ -n "$BUFFER" ]] || return
        BUFFER="${agent} ''${(q)BUFFER}"
        zle end-of-line
        zle accept-line
      }
      zle -N agent-prompt

      # Bind atuin ctrl-r, agent ctrl-y, and edit-command-line ctrl-g
      # (opens the command line in $EDITOR) after zsh-vi-mode initializes
      zvm_after_init() {
        autoload -Uz edit-command-line
        zle -N edit-command-line
        zvm_bindkey viins '^R' atuin-search
        zvm_bindkey vicmd '^R' atuin-search
        zvm_bindkey viins '^Y' agent-prompt
        zvm_bindkey vicmd '^Y' agent-prompt
        zvm_bindkey viins '^G' edit-command-line
        zvm_bindkey vicmd '^G' edit-command-line
      }

      # Disable ctrl-s
      ${pkgs.coreutils}/bin/stty stop undef

      # Export vars
      export EDITOR="${neovim}/bin/nvim"
      if [ -r /run/secrets/cloudflare_api_key ]; then
        export CLOUDFLARE_API_TOKEN="$(${pkgs.coreutils}/bin/cat /run/secrets/cloudflare_api_key)"
      fi

      if [ -r /run/secrets/openrouter_api_key ]; then
        export OPENROUTER_API_KEY="$(${pkgs.coreutils}/bin/cat /run/secrets/openrouter_api_key)"
      fi

      # Functions
      pi() {
        local blank_system_prompt=" "
        case "$1" in
          resume)
            shift
            command pi --system-prompt "$blank_system_prompt" --resume "$@"
            ;;
          ""|-*)
            command pi --system-prompt "$blank_system_prompt" "$@"
            ;;
          install|remove|uninstall|update|list|config|auth)
            command pi "$@"
            ;;
          *)
            printf 'Unknown subcommand: %s\nUse pi -- "your prompt" to start a chat with a prompt.\n' "$1" >&2
            return 1
            ;;
        esac
      }

      ff() {
        ${pkgs.coreutils}/bin/du -a |
          ${pkgs.gawk}/bin/awk '{print $2}' |
          ${pkgs.fzf}/bin/fzf --height 40% --border |
          ${pkgs.findutils}/bin/xargs -r "$EDITOR"
      }

      h() {
        local clipboard_command="${
          if pkgs.stdenv.hostPlatform.isDarwin then "pbcopy" else "${pkgs.wl-clipboard}/bin/wl-copy"
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
