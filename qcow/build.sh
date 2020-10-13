#!/bin/sh
#****************************************************************#
# ScriptName: make_qcow2.sh
# Author: $SHTERM_REAL_USER@alibaba-inc.com
# Create Date: 2019-07-29 16:37
# Modify Author: $SHTERM_REAL_USER@alibaba-inc.com
# Modify Date: 2019-07-29 16:37
# Function:
#***************************************************************#

#[ -f rootfs.qcow2 ] && rm -f rootfs.qcow2
#wget -c http://osimg.alibaba-inc.com/releasedownload/alios7u2-kexin-016-20190722.qcow2  -O rootfs.qcow2

qemu-img snapshot rootfs.qcow2 -c base
modprobe nbd max_part=63
qemu-nbd -c /dev/nbd0 rootfs.qcow2
lsblk
mount /dev/nbd0p3 /mnt
mount /dev/nbd0p2 /mnt/boot
mount /dev/nbd0p1 /mnt/boot/efi
for f in proc sys dev ; do mount --bind /$f /mnt/$f ; done

mount --bind /root/kernel-4.9/ /mnt/mnt/
yum --installroot=/mnt install alios7u-gcc-6-repo.noarch -y
yum --installroot=/mnt install gcc gcc-c++ libstdc++-static gdb coreutils binutils bash -y

cat << EOF | chroot /mnt
cd mnt/
make modules_install install
cd ..
grub2-mkconfig -o boot/efi/EFI/alios/grub.cfg
grub2-mkconfig -o boot/efi/EFI/alios/grub.cfg
sed -i 's/linux16/linuxefi/g' boot/efi/EFI/alios/grub.cfg
sed -i 's/initrd16/initrdefi/g' boot/efi/EFI/alios/grub.cfg
EOF
