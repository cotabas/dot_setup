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

## bluetooth
yay -S bluetuith


# 9700 fingerprint reader
yay -S libfprint-goodix-53xc

sudo systemctl enable --now fprintd.service
sudo cp 50-fprintd.rules /etc/polkit-1/rules.d/
sudo sed -i '1i auth      sufficient  pam_fprintd.so' /etc/pam.d/system-auth

fprintd-enroll
