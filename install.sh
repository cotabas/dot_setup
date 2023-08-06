ln .bashrc ~/.bashrc

ln .gitconfig ~/.gitconfig

mkdir ~/.config/hypr
cp hypr/my_gruv_bg.png ~/.config/hypr/ 
ln hypr/hyprland.conf ~/.config/hypr/hyprland.conf
ln hypr/hyprpaper.conf ~/.config/hypr/hyprpaper.conf

mkdir ~/.config/waybar
ln waybar/config ~/.config/waybar/config
ln waybar/pwr.sh ~/.config/waybar/pwr.sh
ln waybar/style.css ~/.config/waybar/style.css

mkdir ~/.config/kitty/
ln kitty/kitty.conf ~/.config/kitty/kitty.conf
ln kitty/gruvbox.conf ~/.config/kitty/gruvbox.conf

ln starship.toml ~/.config/starship.toml

ln tmux.conf ~/.tmux/tmux.conf

sudo cp lk /usr/sbin/
sudo chmod +x /usr/sbin/lk

sudo cp wpa_init.service /etc/systemd/system/
sudo systemctl enable wpa_init
sudo systemctl start wpa_init

sudo pacman -Syu
sudo pacman -S npm gcc unzip neovim starship tmux ripgrep exa bat

sudo cp /usr/sbin/nvim /usr/sbin/vi

git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

git clone https://github.com/cotabas/nvim ~/.config/nvim/

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

sudo pacman -S noto-fonts bash-completion ttf-inconsolata-nerd ttf-inconsolata powertop

sudo pacman -S alsa-utils pulseaudio pulseaudio-bluetooth pulseaudio-alsa

sudo cp powertop.service /etc/systemd/system/
sudo systemctl enable powertop
sudo systemctl start powertop

echo "prefix + I in tmux to load plugins"
