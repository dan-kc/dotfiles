source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Automatically cd into typed directory.
setopt autocd

# Disable ctrl-s to freeze terminal.
stty stop undef

# Set default editor.
export EDITOR=nvim      

# Aliases.
dot() {du -a ~/.dotfiles | awk '{print $2}' | fzf | xargs -r $EDITOR ; }
proj() {ls -d projects/*/ | fzf | xargs -r $EDITOR ; }

# Allow inline comments.
setopt interactive_comments

# Promt config.

eval "$(starship init zsh)"
