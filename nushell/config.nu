$env.config = {
    ls: {
      use_ls_colors: true
      clickable_links: true
    }
    rm: {
        always_trash: true
      }
    cd: {
        abbreviations: true
      }
      table: {
        mode: light
        index_mode: auto
        show_empty: true
        padding: { left: 1, right: 1 }
        trim: {
            methodology: truncating
            wrapping_try_keep_words: true
            truncating_suffix: "…"
        }
        header_on_separator: false
    }

    completions: {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "prefix"
        external: {
            enable: true
            max_results: 100
            completer: {|spans|
                carapace $spans.0 nushell $spans | from json
            }
        }
    }

    filesize: {
        metric: true
        format: "auto"
    }

    use_grid_icons: true
    footer_mode: "25"
    float_precision: 2
    use_ansi_coloring: true
    bracketed_paste: true
    edit_mode: vi
    shell_integration: true
    show_banner: false
    keybindings:[
     {
      name: edit
      modifier: CONTROL
      keycode: char_e
      mode: [emacs, vi_normal, vi_insert]
      event: [
        { send: OpenEditor }
      ]
    }
    ]
}

source `~/Library/Application Support/nushell/atuin.nu`
source ~/.zoxide.nu
use `~/Library/Application Support/nushell/fnm.nu`

alias ll = ls -l
alias v = nvim
alias c = clear
alias g = lazygit
alias rm = trash
alias x = xplr --print-pwd-as-result
alias l = exa --icons --all
alias ls = exa --icons --all --long
# alias help = tldr --list | fzf --preview "tldr {1} --color=always" --preview-window=right,70% | xargs tldr
# ff() { du -a | awk '{print $2}' | $(fzf --height 40% --border)| xargs -r $EDITOR ; }
# copydir() {pwd | tr -d "\r\n" | pbcopy ; }
# copyfile() {[[ "$#" != 1 ]] && return 1 ; local file_to_copy=$1 ; cat $file_to_copy | pbcopy ; }
# take() {mkdir -p $1 ; cd $1 ; }

source /Users/keone/.config/broot/launcher/nushell/br
