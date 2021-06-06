#!/bin/sh

#set -x
#the image file of OS tar image
IS_EIF=0
BASEOS_TAR_IMAGE=""
TIME=`date "+%Y%m%d_%H%M"`

#yum --installroot=/mnt install gcc-6-repo.noarch -y
function die() {
	echo $1
	exit 1
	#function_body
}

function qcow_create_legacy() {
	#qemu-img snapshot ${TIME}_rootfs.qcow2 -c base
	qemu-img create -f qcow2 ${TIME}_rootfs.qcow2  20G
	modprobe nbd max_part=63
	qemu-nbd -c /dev/nbd0 ${TIME}_rootfs.qcow2
	lsblk
	#format fdisk partation
echo "n



+1024M
n




w
" | fdisk /dev/nbd0


	#format disk filesystem
	mkfs.ext4 /dev/nbd0p2
	mkfs.fat /dev/nbd0p1

	mount /dev/nbd0p2 /mnt
	mkdir /mnt/boot
	mount /dev/nbd0p1 /mnt/boot
}

function qcow_create_efi() {
	#qemu-img snapshot ${TIME}_rootfs.qcow2 -c base
	qemu-img create -f qcow2 ${TIME}_rootfs.qcow2  20G
	modprobe nbd max_part=63
	qemu-nbd -c /dev/nbd0 ${TIME}_rootfs.qcow2
	lsblk
	#format fdisk partation
echo "n



+100M
n



+1024M
n




w
" | fdisk /dev/nbd0

	#format disk filesystem
	mkfs.ext4 /dev/nbd0p3
	mkfs.ext4 /dev/nbd0p2
	mkfs.vfat /dev/nbd0p1

	mount /dev/nbd0p3 /mnt
	mkdir /mnt/boot
	mount /dev/nbd0p2 /mnt/boot
	mkdir /mnt/boot/efi
	mount /dev/nbd0p1 /mnt/boot/efi
}

function buildos_with_yum() {
	yum --installroot=/mnt install gcc gcc-c++ libstdc++-static gdb coreutils binutils bash -y
}

function buildos_with_self_kernel() {
mount --bind /root/kernel-4.9/ /mnt/mnt/
cat << EOF | chroot /mnt
cd mnt/
make modules_install install
cd ..
grub2-mkconfig -o boot/efi/EFI/centos/grub.cfg
sed -i 's/linux16/linuxefi/g' boot/efi/EFI/centos/grub.cfg
sed -i 's/initrd16/initrdefi/g' boot/efi/EFI/centos/grub.cfg
EOF
}

__ScriptVersion="version"

#===  FUNCTION  ================================================================
#         NAME:  usage
#  DESCRIPTION:  Display usage information.
#===============================================================================
function usage ()
{
	echo "Usage :  $0 [options] [--]

    Options:
    -h|help       Display this message
    -v|version    Display script version
    -t|tarimage   install os tar image"

}    # ----------  end of function usage  ----------

if [ $# == 0 ]
then
	usage
	exit 1
fi

__ScriptVersion="1.0"

#-----------------------------------------------------------------------
#  Handle command line arguments
#-----------------------------------------------------------------------

if [ "${USER}" != "root" ]
then
	die "Error, not root access"
fi

while getopts ":hvt:e" opt
do
  case $opt in

	h|help     )  usage; exit 0   ;;

	v|version  )  echo "$0 -- Version $__ScriptVersion"; exit 0   ;;

	t|tarimage     )
		BASEOS_TAR_IMAGE=$OPTARG
		;;
	e|efi     )
		IS_EIF=1
		;;

	* )  echo -e "\n  Option does not exist : $OPTARG\n"
		  usage; exit 1   ;;

  esac    # --- end of case ---
done
shift $(($OPTIND-1))

if [ "${BASEOS_TAR_IMAGE}" != "" ]
then
	if [ $IS_EIF -eq 1 ]
	then
		qcow_create_efi
	else
		qcow_create_legacy
	fi
	tar -pxf ${BASEOS_TAR_IMAGE} -C /mnt
	for f in proc sys dev ; do mount -o bind /$f /mnt/$f ; done

	if [ $IS_EIF -eq 1 ]
	then
cat << EOF | chroot /mnt
grub2-mkconfig -o boot/efi/EFI/centos/grub.cfg
exit
EOF
    else
#sudo cp /mnt/usr/lib/grub/i386-pc/ /mnt/boot/grub2/ -rf
#sudo grub2-install --target=i386-pc  --root-directory=/mnt/  /dev/nbd0p1
cat << EOF | chroot /mnt
grub2-mkconfig
grub2-mkconfig -o boot/grub2/grub.cfg
exit
EOF
	fi

	for f in proc sys dev ; do umount /mnt/$f ; done
	if [ $IS_EIF -eq 1 ]
	then
		umount /mnt/boot/efi
	fi
	#umount /mnt/boot/
	#umount /mnt
	#sudo qemu-nbd -d /dev/nbd0
	echo ""
else
	echo "error"
fi
