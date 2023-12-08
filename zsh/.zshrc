# source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

source ~/.zvi
source ~/.zgeneral
source ~/.zaliases
source ~/.zle

# Atuin config
export ATUIN_NOBIND="true"
bindkey '^r' _atuin_search_widget

eval "$(fnm env --use-on-cd)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(atuin init zsh)"

# Load syntax highlighting; should be last.
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source /Users/keone/.config/broot/launcher/bash/br
