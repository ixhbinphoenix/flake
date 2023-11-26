#!/usr/bin/env bash
set -x

source "/var/lib/libvirt/hooks/kvm.conf"

# Attach devices to host
virsh nodedev-reattach $VIRSH_GPU_VIDEO
virsh nodedev-reattach $VIRSH_GPU_AUDIO
virsh nodedev-reattach $VIRSH_USB_CONTROLLER

modprobe -r vfio-pci

modprobe amdgpu

# echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind

echo 1 > /sys/class/vtconsole/vtcon0/bind
echo 1 > /sys/class/vtconsole/vtcon1/bind

systemctl start greetd

# Return host to all cores
systemctl set-property --runtime -- user.slice AllowedCPUs=0
systemctl set-property --runtime -- user.slice AllowedCPUs=0
systemctl set-property --runtime -- init.scope AllowedCPUs=0
