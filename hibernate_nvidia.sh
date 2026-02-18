#!/bin/bash
# XPS 9700 Post-Install Optimization Script
# Targets: NVIDIA RTX 2060, Deep Sleep (S3), and Battery Life.

echo "--- Starting XPS 9700 Optimization ---"

# 1. Install necessary drivers and tools
# We use nvidia-open-dkms as it's the new standard, but with our 'Legacy' power tweaks.
sudo pacman -S --needed linux-headers nvidia-open-dkms nvidia-utils lib32-nvidia-utils upower lsof
# This daemon keeps the GPU partially awake to 'save time'—we don't want that.
sudo systemctl disable nvidia-persistenced.service

# 2. NVIDIA Power Management Config
# This is the "Magic Formula" that worked for your 20-series card.
sudo tee /etc/modprobe.d/nvidia-power-mgmt.conf <<EOF
# Enable Dynamic Power Management
options nvidia "NVreg_DynamicPowerManagement=0x01"
# Disable GSP Firmware to let the kernel handle sleep (Better for Turing)
options nvidia "NVreg_EnableGpuFirmware=0"
# Power saving tweaks
options nvidia "NVreg_PreserveVideoMemoryAllocations=0"
options nvidia_drm modeset=0 fbdev=0
# Blacklist the buggy I2C controller that causes timeouts
blacklist i2c_nvidia_gpu
EOF

# 3. Udev Rules (Hardware Power Control)
# This forces the GPU, Audio, and USB controllers on the card to suspend.
sudo tee /etc/udev/rules.d/80-nvidia-pm.rules <<EOF
# Power down the GPU when not in use
ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", ATTR{power/control}="auto"

# Power down the Audio, USB, and UCSI controllers on the NVIDIA card
ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto"
ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto"
ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto"
EOF

# 4. The EGL 'Janitor' Service
# Prevents apps from finding the NVIDIA EGL loader by default.
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
After=multi-user.target
[Service]
Type=oneshot
ExecStart=/usr/local/bin/nvidia-egl-fix.sh
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
EOF

# 5. Disable Chatterbox Wakeup Triggers
# Only the Lid and Power Button should wake the laptop.
sudo tee /etc/systemd/system/disable-wakeup.service <<EOF
[Unit]
Description=Disable unnecessary sleep wakeups
[Service]
Type=oneshot
ExecStart=/bin/sh -c "echo PEG0 > /proc/acpi/wakeup; echo XHC > /proc/acpi/wakeup; echo RP01 > /proc/acpi/wakeup; echo RP09 > /proc/acpi/wakeup"
[Install]
WantedBy=multi-user.target
EOF

# 6. Suspend-then-Hibernate Timer
# Ensure systemd allows all sleep verbs
sudo sed -i 's/#AllowSuspend=yes/AllowSuspend=yes/' /etc/systemd/sleep.conf
sudo sed -i 's/#AllowHibernation=yes/AllowHibernation=yes/' /etc/systemd/sleep.conf
sudo sed -i 's/#AllowSuspendThenHibernate=yes/AllowSuspendThenHibernate=yes/' /etc/systemd/sleep.conf
sudo sed -i 's/#HibernateDelaySec=.*/HibernateDelaySec=900/' /etc/systemd/sleep.conf

sudo tee /etc/modprobe.d/i915.conf <<EOF
# Enable Frame Buffer Compression and GuC/HuC for better power management/wake
options i915 enable_fbc=1 enable_guc=3
EOF

# Enable services
sudo systemctl enable nvidia-egl-fix.service
sudo systemctl enable disable-wakeup.service

echo "----------------------------------------------------"
echo "DONE! Manual Steps Required:"
echo "1. Edit /etc/mkinitcpio.conf and add 'resume' to HOOKS (after udev). MAYBE?"
echo "2. Run: sudo mkinitcpio -P"
echo "3. Update your Bootloader (Limine) cmdline with:"
echo "   resume=UUID=<SWAP_UUID>"
echo "----------------------------------------------------"
