ln .bashrc ~/.bashrc

mkdir ~/.config/hypr
ln hypr/* ~/.config/hypr/

mkdir ~/.config/waybar
ln waybar/* ~/.config/waybar/

mkdir ~/.config/kitty/
ln kitty/* ~/.config/kitty/

ln starship.toml ~/.config/

ln tmux.conf ~/.tmux/

cp lk /usr/sbin/
sudo chmod +x /usr/sbin/lk

sudo pacman -Syu
sudo pacman -S npm gcc unzip neovim starship tmux ripgrep exa 

git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

git clone https://github.com/cotabas/nvim ~/.config/nvim/

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "prefix + I in tmux to load plugins"
