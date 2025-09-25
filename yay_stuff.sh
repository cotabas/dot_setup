# I think this needs go installed first so do it after install.sh
#
git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
cd ..
yay -Y --gendb
yay -Syu --devel
yay -S ttf-ms-win10-auto

#hmm
yay -S auto-cpufreq
sudo systemctl enable --now auto-cpufreq

## backlight
yay -S acpilight
sudo cp backlight.rules /etc/udev/rules.d/backlight.rules

