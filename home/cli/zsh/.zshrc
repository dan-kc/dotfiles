# Disable ctrl-s
stty stop undef

source ~/zsh_modules/.zaliases
source ~/zsh_modules/.zle
source ~/zsh_modules/.zsh-vi-mode.zsh

eval "$(fnm env --use-on-cd)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(atuin init zsh --disable-up-arrow)"
function atuin_search() {
    atuin search -i
}
bindkey '^r' atuin_search
