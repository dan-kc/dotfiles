# source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Automatically cd into typed directory.
setopt autocd

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^v' edit-command-line

# Use vi mode
bindkey -v
export KEYTIMEOUT=1

bindkey -M menuselect 'left' vi-backward-char
bindkey -M menuselect 'down' vi-down-line-or-history
bindkey -M menuselect 'up' vi-up-line-or-history
bindkey -M menuselect 'right' vi-forward-char

# Fix bugs when switching modes
bindkey "^?" backward-delete-char
bindkey "^u" backward-kill-line
bindkey "^a" begining-of-line
bindkey "^e" end-of-line
bindkey "^k" kill-line

# Change cursor shape for different vi modes
function zle-keymap-select {
if [[ ${KEYMAP} == vicmd ]] ||
  [[ $1 = 'block' ]]; then
echo -ne '\e[1 q'
elif [[ ${KEYMAP} == main ]] || 
  [[ ${KEYMAP} == viins ]] ||
  [[ ${KEYMAP} = '' ]] ||
  [[ $1 = 'beam' ]]; then
echo -ne '\e[5 q'
fi
}
zle -N zle-keymap-select

# Fix beam cursor not appearing on startup
zle-line-init() {
zle -K viins # initiate `vi insert` as keymap
echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q'
preexec() {echo -ne '\e[5 q'}

# Disable ctrl-s to freeze terminal.
stty stop undef

eval "$(fnm env --use-on-cd)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(atuin init zsh)"
#
# # Set the prompt for normal mode
# export PROMPT_INDICATOR_NORMAL="〉"
#
# # Set the prompt for insert mode
# export PROMPT_INDICATOR_INSERT=": "
#
# # Set the prompt for multiline commands
# export PROMPT_MULTILINE_INDICATOR="::: "
#
# # Customize the prompt string
# function zsh_prompt() {
#     if [[ $KEYMAP == "vicmd" ]]; then
#         PS1="%{$fg[blue]%}$PROMPT_INDICATOR_NORMAL%{$reset_color%} "
#     elif [[ $KEYMAP == "viins" ]]; then
#         PS1="%{$fg[green]%}$PROMPT_INDICATOR_INSERT%{$reset_color%} "
#     else
#         PS1="%{$fg[blue]%}$PROMPT_INDICATOR_NORMAL%{$reset_color%} "
#     fi
# }
#
# # Set the prompt to be updated before each command
# precmd_functions+=(zsh_prompt)
#
# Aliases.
alias v=nvim
alias c=clear
alias g=lazygit
alias rm=trash
alias x='cd "$(xplr --print-pwd-as-result)"'
alias l="erd --human --icons --hidden --level=2"
alias ls='exa -lah'
alias src='source ~/.zshrc'
alias help='tldr --list | fzf --preview "tldr {1} --color=always" --preview-window=right,70% | xargs tldr'
ff() { du -a | awk '{print $2}' | $(fzf --height 40% --border)| xargs -r $EDITOR ; }
copydir() {pwd | tr -d "\r\n" | pbcopy ; }
copyfile() {[[ "$#" != 1 ]] && return 1 ; local file_to_copy=$1 ; cat $file_to_copy | pbcopy ; }
take() {mkdir -p $1 ; cd $1 ; }

# Load syntax highlighting; should be last.
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source /Users/keone/.config/broot/launcher/bash/br
