# Disable ctrl-s
stty stop undef

# Aliases
alias v=nvim
alias c=clear
alias y=yazi
alias g=lazygit
alias rm=trash
alias ls=exa
ff() { du -a | awk '{print $2}' | $(fzf --height 40% --border)| xargs -r $EDITOR ; }
take() {mkdir -p $1 ; cd $1 ; }
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

source ~/zsh_modules/.zsh-vi-mode.zsh
source <(fzf --zsh)

HISTSIZE=100000
SAVEHIST=100000
setopt HIST_SAVE_NODUPS

# [DOESNT WORK] Enable CTRL-E to edit the current line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

# [DOESNT WORK] Enable Y in visual mode to copy to system clipboard
function vi-yank-systemclipboard {
  zle vi-yank
  echo "$CUTBUFFER" | wl-copy
}
zle -N vi-yank-systemclipboard
bindkey -M vicmd 'Y' vi-yank-systemclipboard

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(direnv hook zsh)"
