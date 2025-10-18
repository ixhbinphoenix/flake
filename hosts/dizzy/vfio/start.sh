#!/usr/bin/env bash
set -x

source "/var/lib/libvirt/hooks/kvm.conf"

# Isolate host to Core 0
systemctl set-property --runtime -- user.slice AllowedCPUs=0
systemctl set-property --runtime -- user.slice AllowedCPUs=0
systemctl set-property --runtime -- init.scope AllowedCPUs=0


hyprctl dispatch exit
systemctl stop greetd

echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind

# echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind


# Detach devices from host
virsh nodedev-detach $VIRSH_GPU_VIDEO
virsh nodedev-detach $VIRSH_GPU_AUDIO
virsh nodedev-detach $VIRSH_USB_CONTROLLER

modprobe -r amdgpu

modprobe vfio-pci
