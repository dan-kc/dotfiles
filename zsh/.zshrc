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
alias g=lazygit
alias x=xplr
alias rm=trash
alias l=exa
alias ls='exa -lah'
alias src='source ~/.zshrc'
alias ta='tmux a'
tn() {tmux new -s $(pwd | sed 's/.*\///g')}
ff() { du -a | awk '{print $2}' | $(fzf --height 40% --border)| xargs -r $EDITOR ; }
copydir() {pwd | tr -d "\r\n" | pbcopy ; }
copyfile() {[[ "$#" != 1 ]] && return 1 ; local file_to_copy=$1 ; cat $file_to_copy | pbcopy ; }
take() {mkdir -p $1 ; cd $1 ; }

# Allow inline comments.
setopt interactive_comments

# Promt config.
eval "$(starship init zsh)"

# Load syntax highlighting; should be last.
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
