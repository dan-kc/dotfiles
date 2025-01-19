# Load environment variables from .env file
if [[ -f "$HOME/.config/.env" ]]; then
    set -a
    source "$HOME/.config/.env"
    set +a
fi

export EDITOR=nvim
GOPATH=$HOME/go
PATH=$PATH:$GOPATH/bin
PATH=$HOME/.local/bin:$PATH
