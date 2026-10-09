#!/bin/bash

# Colors for readability
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Ensure script is run with root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run with sudo: sudo $0"
  exit 1
fi

PCI_BUS="0000:01:00.0"
PCI_AUDIO="0000:01:00.1"
CONFIG_FILE="/etc/modprobe.d/nvidia-power-mgmt.conf"
DISABLE_FLAG="/etc/nvidia-completely-disabled"

# Helper to check current state
if [ -f "$DISABLE_FLAG" ]; then
    CURRENT_STATE="DISABLED"
else
    CURRENT_STATE="ACTIVE"
fi

echo "--- Current NVIDIA Power State: $CURRENT_STATE ---"
echo "Select desired mode:"
echo "1) Completely Disable NVIDIA (0W draw, requires reboot)"
echo "2) Enable Normal/Hybrid State (requires reboot)"
read -p "Enter choice [1-2]: " CHOICE

case $CHOICE in
    1)
        echo "Configuring system to completely disable NVIDIA..."
        
        # 1. Blacklist the NVIDIA modules so they won't load
        cat << 'EOF' > "$CONFIG_FILE"
blacklist nvidia
blacklist nvidia_drm
blacklist nvidia_modeset
blacklist nvidia_uvm
blacklist i2c_nvidia_gpu
EOF

        # 2. Create a systemd tmpfiles conf to drop the PCI device on boot automatically
        cat << EOF > /etc/tmpfiles.d/disable-nvidia.txt
w /sys/bus/pci/devices/$PCI_BUS/remove - - - - 1
w /sys/bus/pci/devices/$PCI_AUDIO/remove - - - - 1
EOF

        touch "$DISABLE_FLAG"
        
        # Also drop it immediately from the live bus if possible
        if [ -d "/sys/bus/pci/devices/$PCI_BUS" ]; then
            echo 1 > "/sys/bus/pci/devices/$PCI_BUS/remove" 2>/dev/null
        fi
        if [ -d "/sys/bus/pci/devices/$PCI_AUDIO" ]; then
            echo 1 > "/sys/bus/pci/devices/$PCI_AUDIO/remove" 2>/dev/null
        fi

        echo -e "\n${GREEN}NVIDIA successfully disabled! Please reboot your laptop.${NC}"
        ;;
        
    2)
        echo "Restoring NVIDIA configuration..."
        
        # Restore your preferred coarse-grained config
        cat << 'EOF' > "$CONFIG_FILE"
# Enable Dynamic Power Management (Coarse-grained)
options nvidia "NVreg_DynamicPowerManagement=0x01"
options nvidia "NVreg_EnableGpuFirmware=0"
options nvidia "NVreg_PreserveVideoMemoryAllocations=0"
options nvidia_drm modeset=0 fbdev=0
blacklist i2c_nvidia_gpu
EOF

        # Remove the automated bus-removal rule
        rm -f /etc/tmpfiles.d/disable-nvidia.txt
        rm -f "$DISABLE_FLAG"

        echo -e "\n${GREEN}NVIDIA configuration restored! Please reboot your laptop to bring the card back online.${NC}"
        ;;
        
    *)
        echo "Invalid choice."
        exit 1
        ;;
esac

# Regenerate initramfs to bake changes in
echo "Regenerating initramfs..."
mkinitcpio -P
