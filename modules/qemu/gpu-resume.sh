#!/usr/bin/env bash
set -x

modprobe -r vfio_pci


echo 1 > /sys/class/vtconsole/vtcon0/bind
# echo 1 > /sys/class/vtconsole/vtcon1/bind

virsh nodedev-reattach pci_0000_03_00_0
virsh nodedev-reattach pci_0000_04_00_0

modprobe i915
