source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Automatically cd into typed directory.
setopt autocd

# Disable ctrl-s to freeze terminal.
stty stop undef

# Set default editor.
export EDITOR=nvim      

# Aliases.
alias src='source ~/.zshrc'
dot() {du -a ~/.dotfiles | awk '{print $2}' | fzf | xargs -r $EDITOR ; }
proj() {ls -d projects/*/ | fzf | xargs -r $EDITOR ; }
copydir() {pwd | tr -d "\r\n" | pbcopy ;}
function copyfile {
  [[ "$#" != 1 ]] && return 1
  local file_to_copy=$1
  cat $file_to_copy | pbcopy
}

# Allow inline comments.
setopt interactive_comments

# Promt config.
eval "$(starship init zsh)"

# Load syntax highlighting; should be last.
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
