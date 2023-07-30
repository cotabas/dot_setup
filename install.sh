ln .bashrc ~/.bashrc

ln .gitconfig ~/.gitconfig

mkdir ~/.config/hypr
ln hypr/* ~/.config/hypr/

mkdir ~/.config/waybar
ln waybar/* ~/.config/waybar/

mkdir ~/.config/kitty/
ln kitty/* ~/.config/kitty/

ln starship.toml ~/.config/

ln tmux.conf ~/.tmux/

sudo cp lk /usr/sbin/
sudo chmod +x /usr/sbin/lk

sudo cp wpa_init.service /etc/systemd/system/
sudo systemctl enable wpa_init
sudo systemctl start wpa_init

sudo pacman -Syu
sudo pacman -S npm gcc unzip neovim starship tmux ripgrep exa bat git 

sudo cp /usr/sbin/nvim /usr/sbin/vi

git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

git clone https://github.com/cotabas/nvim ~/.config/nvim/

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

sudo pacman -S noto-fonts bash-completion ttf-inconsolata-nerd ttf-inconsolata powertop

sudo cp powertop.service /etc/systemd/system/
sudo systemctl enable powertop
sudo systemctl start powertop

echo "prefix + I in tmux to load plugins"
