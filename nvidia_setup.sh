# this one actually worx
#
#don't set modset at boot
#

sudo pacman -S --needed linux-headers nvidia-open-dkms nvidia-utils nvidia-prime

cp the 80 rules to /etc/udev/rules.d/
cp the nvidia pow rules to /etc/modprobe.d/


echo "auto" | sudo tee /sys/bus/pci/devices/$(basename $(dirname $(readlink /sys/bus/pci/devices/0000:01:00.0)))/power/control

sudo tee /etc/modprobe.d/i915.conf <<EOF
# Enable Frame Buffer Compression and GuC/HuC for better power management/wake
options i915 enable_fbc=1 enable_guc=3
EOF
sudo mkinitcpio -P

echo "Done! Final manual steps:"
echo "1. Edit /etc/mkinitcpio.conf -> MODULES=(i915 nvidia nvidia_modeset nvidia_uvm nvidia_drm)"
echo "2. Run 'sudo mkinitcpio -P'"
echo "3. Reboot."

