echo "before you run this script, have the following done:"
echo "run pre_user.sh"
echo "create a user and be logged in as that user"
echo "they should be in the wheel group and the video group"
echo "add wheel to the sudoers file"
echo "copy ssh keys to ~/.ssh/"
echo "ping google.com"
read -p "Continue? (y/n): " answer
case $answer in
    [Yy]* ) echo "Continuing...";;
    [Nn]* ) exit 1;;
    * ) echo "Please answer yes or no."; exit 1;;
esac

# This finds the directory where the script itself lives
DOTFILES_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

# Function to safely link
link_file() {
    src=$1
    dst=$2
    mkdir -p "$(dirname "$dst")"
    ln -sf "$DOTFILES_DIR/$src" "$dst"
}

echo "Linking config files..."
link_file "bashrc" "$HOME/.bashrc"
link_file "tmux.conf" "$HOME/.tmux.conf"
link_file ".gitconfig" "$HOME/.gitconfig"
link_file "hypr/hyprland.conf" "$HOME/.config/hypr/hyprland.conf"
link_file "hypr/hyprpaper.conf" "$HOME/.config/hypr/hyprpaper.conf"
link_file "hypr/hypridle.conf" "$HOME/.config/hypr/hypridle.conf"
link_file "hypr/hyprlock.conf" "$HOME/.config/hypr/hyprlock.conf"
link_file "waybar/config.jsonc" "$HOME/.config/waybar/config.jsonc"
link_file "waybar/style.css" "$HOME/.config/waybar/style.css"
link_file "wofi/style.css" "$HOME/.config/wofi/style.css"
link_file "foot/foot.ini" "$HOME/.config/foot/foot.ini"
link_file "starship.toml" "$HOME/.config/starship.toml"
link_file "fontconfig/fonts.conf" "$HOME/.config/fontconfig/fonts.conf"
link_file "swayosd/style.css" "$HOME/.config/swayosd/style.css"
link_file "chromium-flags.conf" "$HOME/.config/chromium-flags.conf"
link_file "btop/btop.conf" "$HOME/.config/btop/btop.conf"

sudo rm /etc/hosts

sudo ln -sf hosts /etc/hosts
sudo ln -sf tlp.conf /etc/tlp.conf
sudo chmod +x /usr/sbin/lk

cp hypr/my_gruv_bg.png ~/.config/hypr/
cp waybar/pwr.sh ~/.config/waybar/

# Package groups
XPS_PKGS=(intel-media-driver tlp tlp-rdw)
HW_PKGS=(alsa-utils acpi pipewire-alsa pipewire-pulse sof-firmware bluez bluez-utils)
CORE_PKGS=(openssh git base-devel man nvm npm gcc unzip tmux neovim go btop gdb gef)
WM_PKGS=(hyprland waybar foot wofi hyprpaper hypridle hyprlock grim slurp hyprpicker chromium swayosd)
UTIL_PKGS=(ripgrep eza bat wl-clipboard wl-clip-persist starship dunst bash-completion)
FONT_PKGS=(ttf-inconsolata-nerd noto-fonts noto-fonts-emoji fontconfig)

echo "Installing packages..."
sudo pacman -S --needed "${HW_PKGS[@]}" "${XPS_PKGS[@]}" "${CORE_PKGS[@]}" "${WM_PKGS[@]}" "${UTIL_PKGS[@]}" "${FONT_PKGS[@]}"

echo "Setting up ssh keys..."
eval "$(ssh-agent -s)"
chmod 600 ~/.ssh/id_ed25519
ssh-add ~/.ssh/id_ed25519
chmod 600 ~/.ssh/id_ed25519_github
ssh-add ~/.ssh/id_ed25519_github

git remote set-url origin git@github.com:cotabas/dot_setup/

sudo cp dunstrc /etc/dunst/dunstrc
fc-cache -f -v

echo "Enabling services..."
sudo systemctl enable --now bluetooth
sudo systemctl enable --now swayosd-libinput-backend.service
sudo systemctl enable --now tlp
systemctl enable --user --now pipewire

echo "Neovim setup..."
# Check if the directory DOES NOT exist (-d is for directory, ! is 'not')
if [ ! -d "$HOME/.config/nvim" ]; then
    git clone git@github.com:cotabas/nvim_lazy "$HOME/.config/nvim"
else
    echo "Neovim config already exists, skipping clone..."
fi

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# if i return to firefox
# echo "Get https://github.com/adriankarlen/textfox"
# echo "https://github.com/yokoffing/Betterfox"
# echo "basically copy the ffuser.js to the right profile"

echo "prefix + I in tmux to load plugins"
echo "do pacman -Syu"
echo "run setup_nvidia.sh"
echo "run yay_stuff.sh"


