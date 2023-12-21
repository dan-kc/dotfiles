# source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

source ~/.zgeneral
source ~/.zaliases
source ~/.zle
source ~/.zplugins/zsh-vi-mode.zsh
source ~/.zimfw

# Atuin config
export ATUIN_NOBIND="true"

eval "$(fnm env --use-on-cd)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(atuin init zsh --disable-up-arrow)"

source /Users/keone/.config/broot/launcher/bash/br
