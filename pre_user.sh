##
#
# Run this when chrooted into the system before first login
# 
##
pacman -S dhcpcd
pacman -S wpa_supplicant
cp wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant-wlp0s020f3.conf
cp wpa_init.service /etc/systemd/system/
systemctl enable wpa_init
systemctl enable dhcpcd

touch /etc/modprobe.d/blacklist-nouveau.conf
echo "blacklist nouveau" >> /etc/modprobe.d/blacklist-nouveau.conf
echo "options nouveau modeset=0" >> /etc/modprobe.d/blacklist-nouveau.conf
cp 00-remove-nvidia.rules /etc/udev/rules.d/00-remove-nvidia.rules

#wpa_supplicant -B -i wlp0s20f3 -c /etc/wpa_supplicant/wpa_supplicant.conf
#dhcpcd wlp0s20f3
