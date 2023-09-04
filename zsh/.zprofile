# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

export EDITOR=nvim      
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Load environment variables from .env file
if [[ -f "$HOME/.config/.env" ]]; then
    set -a
    source "$HOME/.config/.env"
    set +a
fi

# ~/.config/tmux/plugins
export PATH=$HOME/.config/tmux/plugins/t-smart-tmux-session-manager/bin:$PATH
