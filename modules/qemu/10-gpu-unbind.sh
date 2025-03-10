#!/usr/bin/env bash
set -x
rmmod -f i915

echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind

sleep 2

virsh nodedev-detach pci_0000_03_00_0
virsh nodedev-detach pci_0000_04_00_0

modprobe vfio-pci
