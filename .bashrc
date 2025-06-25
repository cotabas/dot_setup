
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

