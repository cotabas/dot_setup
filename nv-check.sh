#!/bin/bash

# Colors for readability
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "--- NVIDIA Power Management Health Check ---"

# 1. Check PCI Status (The Source of Truth)
PCI_STATUS=$(cat /sys/bus/pci/devices/0000:01:00.0/power/runtime_status)
if [ "$PCI_STATUS" == "suspended" ]; then
    echo -e "PCI Status: ${GREEN}SUSPENDED (Card is Off)${NC}"
else
    echo -e "PCI Status: ${RED}ACTIVE (Card is Drawing Power)${NC}"
fi

# 2. Check for "Zombie" Handles
HANDLES=$(sudo lsof /dev/nvidia* 2>/dev/null | grep -v "COMMAND")
if [ -z "$HANDLES" ]; then
    echo -e "Processes: ${GREEN}None (Clean)${NC}"
else
    echo -e "Processes: ${RED}STUCK HANDLES DETECTED:${NC}"
    echo "$HANDLES"
fi

# 3. Check EGL Vendor Priority
if [ -f /usr/share/glvnd/egl_vendor.d/10_nvidia.json ]; then
    echo -e "EGL Priority: ${RED}BAD (NVIDIA is at 10_)${NC}"
else
    echo -e "EGL Priority: ${GREEN}GOOD (NVIDIA is Deprioritized)${NC}"
    #sudo mv /usr/share/glvnd/egl_vendor.d/10_nvidia.json /usr/share/glvnd/egl_vendor.d/90_nvidia.json
fi

# 4. Check Kernel Flags
MODESET=$(sudo cat /sys/module/nvidia_drm/parameters/modeset)
if [ "$MODESET" == "N" ] || [ "$MODESET" == "0" ]; then
    echo -e "Modesetting: ${GREEN}OFF (Correct for Laptop Power)${NC}"
else
    echo -e "Modesetting: ${RED}ON (May prevent sleep)${NC}"
fi
