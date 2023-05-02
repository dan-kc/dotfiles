source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Automatically cd into typed directory.
setopt autocd

# Disable ctrl-s to freeze terminal.
stty stop undef

# Set default editor.
export EDITOR=nvim      
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Zoxide setup.
eval "$(zoxide init zsh)"

# Aliases.
alias c=clear
tn() {tmux new -s $(pwd | sed 's/.*\///g')}
alias ta='tmux a'
alias g=lazygit
alias x=xplr
alias src='source ~/.zshrc'
alias l='exa -lah'
alias ls=exa
alias rm=trash
# alias z='zellij'
alias za='zellij attach'
# alias f='nvim $(fzf --height 40% --border)'
alias dot='cd ~/.dotfiles'
alias proj='cd ~/projects'
ff() { du -a | awk '{print $2}' | $(fzf --height 40% --border)| xargs -r $EDITOR ; }
# proj() {ls -d ~/projects/*/ | fzf | xargs -r $EDITOR ; }
# dot() {cd ~/.dotfiles ; du -a ~/.dotfiles | awk '{print $2}' | fzf | xargs -r $EDITOR ; }
copydir() {pwd | tr -d "\r\n" | pbcopy ; }
copyfile() {[[ "$#" != 1 ]] && return 1 ; local file_to_copy=$1 ; cat $file_to_copy | pbcopy ; }
take() {mkdir -p $1 ; cd $1 ; }

# Allow inline comments.
setopt interactive_comments

# Promt config.
eval "$(starship init zsh)"

# Load syntax highlighting; should be last.
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
