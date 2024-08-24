# source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Disable ctrl-s
stty stop undef

source ~/zsh_modules/.zaliases
source ~/zsh_modules/.zle
source ~/zsh_modules/.zsh-vi-mode.zsh
# source ~/zsh_modules/.zimfw

# Atuin config
export ATUIN_NOBIND="true"

eval "$(fnm env --use-on-cd)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(atuin init zsh --disable-up-arrow)"

# source /Users/danielcox/.config/broot/launcher/bash/br
