{
  pkgs,
  ...
}:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;

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

    initExtra = ''
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

      take() { mkdir -p $1 ; cd $1 ; }

      function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
      }

      # ── Git helpers ──────────────────────────────────────────
      # Prints the command then runs it
      _gr() { echo "→ $@"; command "$@" }

      # Status / log
      gs()  { _gr git status "$@" }
      gl()  { _gr git log --oneline --graph --all --max-count=20 "$@" }
      gll() { _gr git log --oneline --graph --all "$@" }
      glp() { _gr git log --patch "$@" }

      # Diff
      gd()  { _gr git diff "$@" }
      gds() { _gr git diff --staged "$@" }

      # Add
      ga()  { _gr git add "$@" }
      gaa() { _gr git add --all "$@" }
      gap() { _gr git add --patch "$@" }

      # Commit
      gc()  { _gr git commit "$@" }
      gcm() { _gr git commit -m "$@" }
      gca() { _gr git commit --amend "$@" }

      # Push / pull
      gp()   { _gr git push "$@" }
      gpf()  { _gr git push --force-with-lease "$@" }
      gpl()  { _gr git pull "$@" }

      # Switch (no checkout)
      gsw() { _gr git switch "$@" }
      gsc() { _gr git switch -c "$@" }

      # Branch
      gb()  { _gr git branch "$@" }
      gbd() { _gr git branch -d "$@" }

      # Rebase
      grb()  { _gr git rebase "$@" }
      grbi() { _gr git rebase -i "$@" }

      # Stash
      gst()  { _gr git stash "$@" }
      gstp() { _gr git stash pop "$@" }
      gstl() { _gr git stash list "$@" }

      # Cherry-pick
      gcp() { _gr git cherry-pick "$@" }

      # Reset
      grh() { _gr git reset HEAD "$@" }

      # ── Interactive fzf scripts (lazygit replacements) ──────

      # Interactive stage files (multi-select with tab)
      gai() {
        local files
        files=$(git status --short | fzf --multi --height 80% --border \
          --preview 'git diff --color=always -- {2}' \
          --header 'TAB to select multiple, ENTER to stage' | awk '{print $2}')
        [[ -z "$files" ]] && return
        echo "$files" | xargs git add
        git status --short
      }

      # Interactive unstage files
      gui() {
        local files
        files=$(git diff --staged --name-only | fzf --multi --height 80% --border \
          --preview 'git diff --staged --color=always -- {}' \
          --header 'TAB to select, ENTER to unstage')
        [[ -z "$files" ]] && return
        echo "$files" | xargs git restore --staged
        git status --short
      }

      # Interactive branch switch
      gbf() {
        local branch
        branch=$(git branch --all --sort=-committerdate --format='%(refname:short)' \
          | fzf --height 40% --border \
            --preview 'git log --oneline --graph --max-count=15 {}')
        [[ -z "$branch" ]] && return
        # Strip remotes/origin/ prefix for remote branches
        branch=''${branch#origin/}
        _gr git switch "$branch"
      }

      # Interactive log browser — view diffs per commit
      glf() {
        git log --oneline --all --color=always | fzf --ansi --height 80% --border \
          --preview 'git show --color=always --stat --patch {1}' \
          --header 'Browse commits (scroll preview with shift+up/down)' \
          --bind 'enter:execute(git show --color=always {1} | less -R)'
      }

      # Interactive fixup: pick a commit to fixup into
      gfix() {
        local commit
        commit=$(git log --oneline -30 | fzf --height 40% --border \
          --header 'Pick commit to fixup into' \
          --preview 'git show --color=always --stat {1}' | awk '{print $1}')
        [[ -z "$commit" ]] && return
        _gr git commit --fixup="$commit" "$@"
        echo "Run 'grba' to autosquash into the target commit"
      }

      # Autosquash rebase onto merge-base with main
      grba() {
        local base
        base=$(git merge-base HEAD main)
        _gr git rebase -i --autosquash "$base"
      }

      # Interactive stash browser
      gstf() {
        local stash
        stash=$(git stash list | fzf --height 40% --border \
          --preview 'git stash show --color=always --patch $(echo {} | cut -d: -f1)' | cut -d: -f1)
        [[ -z "$stash" ]] && return
        _gr git stash apply "$stash"
      }

      # WIP: quick save / undo
      gwip() {
        _gr git add --all
        _gr git commit -m "WIP"
      }
      gunwip() {
        if [[ "$(git log -1 --format=%s)" == "WIP" ]]; then
          _gr git reset HEAD~1
        else
          echo "Last commit is not a WIP commit"
        fi
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
