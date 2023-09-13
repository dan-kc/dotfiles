$env.config = {
    show_banner: false,
    keybindings:[]
}
source `~/Library/Application Support/nushell/atuin.nu`
source ~/.zoxide.nu

alias ll = ls -l
alias v = nvim
alias c = clear
alias g = lazygit
alias rm = trash
alias x = xplr --print-pwd-as-result
alias l = exa --icons --all
alias ls = exa --icons --all --long
alias ta = tmux a
alias tk = tmux kill-server
# alias help = tldr --list | fzf --preview "tldr {1} --color=always" --preview-window=right,70% | xargs tldr
# tn() {tmux new -s $(pwd | sed 's/.*\///g')}
# ff() { du -a | awk '{print $2}' | $(fzf --height 40% --border)| xargs -r $EDITOR ; }
# copydir() {pwd | tr -d "\r\n" | pbcopy ; }
# copyfile() {[[ "$#" != 1 ]] && return 1 ; local file_to_copy=$1 ; cat $file_to_copy | pbcopy ; }
# take() {mkdir -p $1 ; cd $1 ; }
