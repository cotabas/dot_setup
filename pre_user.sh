##
#
# Run this when chrooted into the system before first login
# 
##
#pacman -S wpa_supplicant
#cp wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant-wlp0s020f3.conf
#cp wpa_init.service /etc/systemd/system/
#systemctl enable wpa_init
pacman -S iwd
pacman -S dhcpcd
pacman -S impala
systemctl enable dhcpcd
systemctl enable iwd

##Keep the nvidia GPU off
#https://wiki.archlinux.org/title/Hybrid_graphics#Fully_power_down_discrete_GPU
#touch /etc/modprobe.d/blacklist-nouveau.conf
#echo "blacklist nouveau" >> /etc/modprobe.d/blacklist-nouveau.conf
#echo "options nouveau modeset=0" >> /etc/modprobe.d/blacklist-nouveau.conf
#cp 00-remove-nvidia.rules /etc/udev/rules.d/00-remove-nvidia.rules
