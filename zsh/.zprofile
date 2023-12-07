# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

# Load environment variables from .env file
if [[ -f "$HOME/.config/.env" ]]; then
    set -a
    source "$HOME/.config/.env"
    set +a
fi

export EDITOR=nvim
GOPATH=$HOME/go
PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"
PATH=$PATH:$GOPATH/bin
PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.config/tmux/plugins/t-smart-tmux-session-manager/bin:$PATH
