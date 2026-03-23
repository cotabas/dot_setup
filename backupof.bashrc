
__main() {
  local major="${BASH_VERSINFO[0]}"
  local minor="${BASH_VERSINFO[1]}"

  if ((major > 4)) || { ((major == 4)) && ((minor >= 1)); }; then
    source <(/usr/bin/starship init bash --print-full-init)
  else
    source /dev/stdin <<<"$(/usr/bin/starship init bash --print-full-init)"
  fi
}
__main
unset -f __main
#eval "$(~/.rbenv/bin/rbenv init - bash)"
source /usr/share/nvm/init-nvm.sh
#export PATH="$PATH:/opt/android-studio/bin"
alias vi="nvim"

lk() {
    eza --icons --git -l "$@"
}
# Created by `pipx` on 2023-11-05 03:23:51
export PATH="$PATH:/home/cptmo/.local/bin"

export GOPATH=$HOME/go
export PATH="$PATH:$GOPATH/bin"

export GTK_THEME=Gruvbox-Plus-Dark
export QT_QPA_PLATFORM=wayland
export QT_QPA_PLATFORMTHEME=kde
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export QT_AUTO_SCREEN_SCALE_FACTOR=1

export QT_STYLE_OVERRIDE=kvantum



# --- 1. PROMPT ---
eval "$(starship init bash)"

# --- 2. ALIASES & FUNCTIONS ---
alias vi="nvim"
alias vim="nvim"

lk() {
    eza --icons --git -l --group-directories-first "$@"
}

# NVM Lazy Loader
# We create 'placeholder' functions for the commands you actually use.
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
export GTK_THEME=Gruvbox-Plus-Dark
export QT_QPA_PLATFORM="wayland;xcb"
export MOZ_ENABLE_WAYLAND=1
export ELECTRON_OZONE_PLATFORM_HINT=auto

export GOPATH=$HOME/go
# (Use the add_to_path function we discussed earlier)
add_to_path "$HOME/.local/bin"
add_to_path "$GOPATH/bin"
