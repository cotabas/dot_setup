
echo "before you run this script, have the following done:"
echo "run pre_user.sh"
echo "create a user and be logged in as that user"
echo "they should be in the wheel group and the video group"
echo "copy ssh keys to ~/.ssh/"
echo "ping google.com"
read -p "Continue? (y/n): " answer
case $answer in
    [Yy]* ) echo "Continuing...";;
    [Nn]* ) exit 1;;
    * ) echo "Please answer yes or no."; exit 1;;
esac

sudo pacman -S openssh
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
ssh-add ~/.ssh/id_ed25519_github

git remote set-url origin git@github.com:cotabas/dot_setup/

rm ~/.bashrc
ln .bashrc ~/.bashrc


mkdir ~/repos/


ln .gitconfig ~/.gitconfig

mkdir ~/.config
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

sudo rm /etc/hosts
sudo ln hosts /etc/hosts

sudo cp lk /usr/sbin/
sudo chmod +x /usr/sbin/lk
##
#  Install stuff
##
sudo pacman -S alsa-utils 
sudo pacman -S acpi 
sudo pacman -S pipewire-alsa 
sudo pacman -S sof-firmware 
sudo pacman -S man 
sudo pacman -S npm 
sudo pacman -S gcc 
sudo pacman -S unzip 
sudo pacman -S starship 
sudo pacman -S tmux 
sudo pacman -S ripgrep 
sudo pacman -S exa 
sudo pacman -S bat 
sudo pacman -S base-devel 
sudo pacman -S hyprland 
sudo pacman -S waybar 
sudo pacman -S kitty 
sudo pacman -S hyprpaper 
sudo pacman -S wofi 
sudo pacman -S grim 
sudo pacman -S slurp 
sudo pacman -S hypridle 
sudo pacman -S firefox 
sudo pacman -S noto-fonts 
sudo pacman -S bash-completion 
sudo pacman -S ttf-inconsolata-nerd 
sudo pacman -S ttf-inconsolata 
sudo pacman -S blueman
sudo pacman -S nvm 
wait

git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
cd ..
yay -Y --gendb
yay -Syu --devel
yay -S ttf-ms-win10-auto


#9700 stuff start:
#
# wifi for 9700
#
#sudo cp wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf
#sudo cp wpa_init.service /etc/systemd/system/
#sudo systemctl enable wpa_init
#sudo systemctl start wpa_init

pacman -S intel-media-driver

sudo pacman -S tlp 
sudo pacman -S tlp-rdw
sudo ln tlp.conf /etc/tlp.conf
sudo systemctl enable tlp
sudo systemctl start tlp

systemctl --user enable pipewire
systemctl --user start pipewire


## backlight
yay -S acpilight
sudo cp backlight.rules /etc/udev/rules.d/backlight.rules

##Keep the GPU off
#https://wiki.archlinux.org/title/Hybrid_graphics#Fully_power_down_discrete_GPU
sudo touch /etc/modprobe.d/blacklist-nouveau.conf
sudo echo "blacklist nouveau" >> /etc/modprobe.d/blacklist-nouveau.conf
sudo echo "options nouveau modeset=0" >> /etc/modprobe.d/blacklist-nouveau.conf
sudo cp 00-remove-nvidia.rules /etc/udev/rules.d/00-remove-nvidia.rules

#
#9700 end.


##
#   vim stuff
##
sudo pacman -S neovim 
sudo rm /usr/sbin/vi
sudo ln /usr/sbin/nvim /usr/sbin/vi

git clone https://github.com/cotabas/lazy_nvim 
mv lazy_nvim ~/.config/nvim

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

yay -S onedrive-abraunegg
sudo cp onedrive.service /etc/systemd/system/
sudo systemctl enable onedrive
sudo systemctl start onedrive

## Powertop isn't a as good as tlp?
#sudo pacman -S powertop
#sudo cp powertop.service /etc/systemd/system/
#sudo systemctl enable powertop
#sudo systemctl start powertop

echo "prefix + I in tmux to load plugins"
echo "Get https://github.com/adriankarlen/textfox"
echo "https://github.com/yokoffing/Betterfox"
echo "basically copy the ffuser.js to the right profile"
echo "do pacman -Syu"
