# --- 1. PROMPT ---
# Only run this if the shell is interactive
if [[ $- == *i* ]]; then
    eval "$(starship init bash)"
fi

# --- 2. ALIASES & FUNCTIONS ---
alias vi="nvim"
alias H="start-hyprland"

lk() {
    eza --icons --git -l --group-directories-first "$@"
}

# NVM Lazy Loader
nvm() {
    unset -f nvm node npm  # Delete these placeholders
    source /usr/share/nvm/init-nvm.sh  # Load the real NVM
    nvm "$@"  # Run the real nvm command with your arguments
}

node() {
    unset -f nvm node npm
    source /usr/share/nvm/init-nvm.sh
    node "$@"
}

npm() {
    unset -f nvm node npm
    source /usr/share/nvm/init-nvm.sh
    npm "$@"
}

# --- 3. EXPORTS & PATH ---
add_to_path() {
    if [[ ":$PATH:" != *":$1:"* ]] && [ -d "$1" ]; then
        export PATH="$1:$PATH"
    fi
}

export EDITOR='nvim'
export VISUAL='nvim'
export GTK_THEME=Gruvbox-Plus-Dark
export QT_QPA_PLATFORM="wayland;xcb"
export MOZ_ENABLE_WAYLAND=1
export ELECTRON_OZONE_PLATFORM_HINT=auto

export GOPATH=$HOME/go
add_to_path "$HOME/.local/bin"
add_to_path "$GOPATH/bin"
