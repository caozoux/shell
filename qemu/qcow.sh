#!/bin/bash

if [ -f testimage.qcow2 ]
then
	rm testimage.qcow2
fi

qemu-img create -f qcow2 testimage.qcow2 40G

modprobe nbd max_part=63

qemu-nbd -c /dev/nbd0 testimage.qcow2 

fdisk /dev/nbd0 <<EOF
n
p


+100M
n
p


+300M
n
p



wq
EOF

mkfs.vfat /dev/nbd0p1
mkfs.ext4 /dev/nbd0p2
mkfs.ext4 /dev/nbd0p3

mount /dev/nbd0p3 /mnt
mkdir /mnt/boot
mount /dev/nbd0p2 /mnt/boot
mkdir /mnt/boot/efi
mount /dev/nbd0p1 /mnt/boot/efi
tar  --xattrs --xattrs-include='*.*' --numeric-owner -pxvf $1  -C /mnt
umount /mnt/boot/efi
umount /mnt/boot/
umount /mnt/
qemu-nbd -d /dev/nbd0
exit
