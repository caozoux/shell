#!/bin/sh

qemu-img snapshot rootfs.qcow2 -c base
modprobe nbd max_part=63
qemu-nbd -c /dev/nbd0 rootfs.qcow2
lsblk
mount /dev/nbd0p3 /mnt
mount /dev/nbd0p2 /mnt/boot
mount /dev/nbd0p1 /mnt/boot/efi
for f in proc sys dev ; do mount --bind /$f /mnt/$f ; done

mount --bind /root/kernel-4.9/ /mnt/mnt/
#yum --installroot=/mnt install gcc-6-repo.noarch -y
yum --installroot=/mnt install gcc gcc-c++ libstdc++-static gdb coreutils binutils bash -y

cat << EOF | chroot /mnt
cd mnt/
make modules_install install
cd ..
grub2-mkconfig -o boot/efi/EFI/centos/grub.cfg
grub2-mkconfig -o boot/efi/EFI/centos/grub.cfg
sed -i 's/linux16/linuxefi/g' boot/efi/EFI/centos/grub.cfg
sed -i 's/initrd16/initrdefi/g' boot/efi/EFI/centos/grub.cfg
EOF
