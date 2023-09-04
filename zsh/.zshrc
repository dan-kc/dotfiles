# source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Automatically cd into typed directory.
setopt autocd

# Disable ctrl-s to freeze terminal.
stty stop undef

eval "$(fnm env --use-on-cd)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(atuin init zsh)"

# Aliases.
alias v=nvim
alias c=clear
alias g=lazygit
alias rm=trash
alias x='cd "$(xplr --print-pwd-as-result)"'
alias l="erd --human --icons --hidden --level=2"
alias ls='exa -lah'
alias src='source ~/.zshrc'
alias ta='tmux a'
alias tk='tmux kill-server'
alias help='tldr --list | fzf --preview "tldr {1} --color=always" --preview-window=right,70% | xargs tldr'
tn() {tmux new -s $(pwd | sed 's/.*\///g')}
ff() { du -a | awk '{print $2}' | $(fzf --height 40% --border)| xargs -r $EDITOR ; }
copydir() {pwd | tr -d "\r\n" | pbcopy ; }
copyfile() {[[ "$#" != 1 ]] && return 1 ; local file_to_copy=$1 ; cat $file_to_copy | pbcopy ; }
take() {mkdir -p $1 ; cd $1 ; }

# Load syntax highlighting; should be last.
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
