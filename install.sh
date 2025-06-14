






ln .bashrc ~/.bashrc



mkdir ~/repos/


ln .gitconfig ~/.gitconfig

mkdir ~/.config/hypr
cp hypr/my_gruv_bg.png ~/.config/hypr/ 
ln hypr/hyprland.conf ~/.config/hypr/hyprland.conf
ln hypr/hyprpaper.conf ~/.config/hypr/hyprpaper.conf
ln hypr/hypridle.conf ~/.config/hypr/hypridle.conf

mkdir ~/.config/waybar
ln waybar/config ~/.config/waybar/config
ln waybar/pwr.sh ~/.config/waybar/pwr.sh
ln waybar/style.css ~/.config/waybar/style.css

mkdir ~/.config/kitty/
ln kitty/kitty.conf ~/.config/kitty/kitty.conf
ln kitty/gruvbox.conf ~/.config/kitty/gruvbox.conf

mkdir ~/.config/wofi
ln wofi/style.css ~/.config/wofi/style.css

ln starship.toml ~/.config/starship.toml

ln tmux.conf ~/.tmux.conf

sudo ln hosts /etc/hosts

sudo cp lk /usr/sbin/
sudo chmod +x /usr/sbin/lk

#9700 stuff start:
#
# wifi for 9700
#
sudo cp wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf
sudo cp wpa_init.service /etc/systemd/system/
sudo systemctl enable wpa_init
sudo systemctl start wpa_init

sudo pacman -S alsa-utils acpi acpilight pipewire-alsa sof-firmware tlp

ln tlp.conf /etc/tlp.conf
sudo systemctl enable tlp
sudo systemctl start tlp

systemctl --user enable pipewire
systemctl --user start pipewire


##Keep the GPU off
#https://wiki.archlinux.org/title/Hybrid_graphics#Fully_power_down_discrete_GPU
sudo touch /etc/modprobe.d/blacklist-nouveau.conf
sudo echo "blacklist nouveau" >> /etc/modprobe.d/blacklist-nouveau.conf
sudo echo "options nouveau modeset=0" >> /etc/modprobe.d/blacklist-nouveau.conf
sudo cp 00-remove-nvidia.rules /etc/udev/rules.d/00-remove-nvidia.rules

#
#9700 end.

sudo pacman -Syu
sudo pacman -S man npm gcc unzip neovim starship tmux ripgrep exa bat base-devel yay 
sudo pacman -S hyprland waybar kitty hyprpaper wofi grim slurp hypridle firefox

sudo ln /usr/sbin/nvim /usr/sbin/vi

git clone https://github.com/cotabas/nvim ~/.config/nvim/
cd ~/.config/nvim/
git remote set-url origin git@github.com:cotabas/nvim.git
cd -
echo "This might not work, throwing it in untested.."

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

sudo pacman -S noto-fonts bash-completion ttf-inconsolata-nerd ttf-inconsolata 
yay -S ttf-ms-win11-auto

yay -S onedrive-abraunegg
sudo cp onedrive.service /etc/systemd/system/
sudo systemctl enable onedrive
sudo systemctl start onedrive

#sudo pacman -S powertop
#sudo cp powertop.service /etc/systemd/system/
#sudo systemctl enable powertop
#sudo systemctl start powertop

#sudo mkdir /opt/pomodoro/
#sudo chown cptmo /opt/pomodoro/
#sudo ln pomodoro/pomodoro.desktop /usr/share/applications/
#ln pomodoro/pomodoro /opt/pomodoro/
#git clone https://github.com/cotabas/pomodoro ~/repos/pomodoro/

echo "prefix + I in tmux to load plugins"
echo "Get testfox?"

