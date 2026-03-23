#!/bin/bash
# Arch Linux Hybrid Power Setup for XPS 9700 / RTX 2060
# Run this after installing 'nvidia' and 'nvidia-utils'
sudo pacman -S --needed linux-headers nvidia-open-dkms nvidia-utils

echo "Configuring NVIDIA for maximum power savings..."

# 1. Modprobe Config (The Tuning Parameters)
sudo tee /etc/modprobe.d/nvidia-power-mgmt.conf <<EOF
options nvidia "NVreg_DynamicPowerManagement=0x01"
options nvidia "NVreg_EnableGpuFirmware=0"
options nvidia "NVreg_PreserveVideoMemoryAllocations=0"
options nvidia_drm modeset=0 fbdev=0
EOF

# 2. Udev Rules (The Gatekeeper)
sudo tee /etc/udev/rules.d/80-nvidia-pm.rules <<EOF
ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", ATTR{power/control}="auto"
ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto"
EOF

# 3. Setup the Janitor Service (The Auto-Fix)
sudo tee /usr/local/bin/nvidia-egl-fix.sh <<EOF
#!/bin/bash
if [ -f /usr/share/glvnd/egl_vendor.d/10_nvidia.json ]; then
    mv /usr/share/glvnd/egl_vendor.d/10_nvidia.json /usr/share/glvnd/egl_vendor.d/90_nvidia.json
fi
EOF
sudo chmod +x /usr/local/bin/nvidia-egl-fix.sh

sudo tee /etc/systemd/system/nvidia-egl-fix.service <<EOF
[Unit]
Description=Ensure NVIDIA EGL is deprioritized
[Service]
Type=oneshot
ExecStart=/usr/local/bin/nvidia-egl-fix.sh
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable nvidia-egl-fix.service

echo "Done! Final manual steps:"
echo "1. Edit /etc/mkinitcpio.conf -> MODULES=(i915 nvidia nvidia_modeset nvidia_uvm nvidia_drm)"
echo "2. Run 'sudo mkinitcpio -P'"
echo "3. Reboot."
