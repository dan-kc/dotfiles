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

HISTSIZE=100000
SAVEHIST=100000
setopt HIST_SAVE_NODUPS

source ~/zsh_modules/.zsh-vi-mode.zsh

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(direnv hook zsh)"
