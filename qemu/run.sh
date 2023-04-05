#!/bin/bash
set -x

__ScriptVersion="1.0"

function die() {
	#function_body
	echo "Exit err:" $1
}
#===  FUNCTION  ================================================================
#         NAME:  usage
#  DESCRIPTION:  Display usage information.
#===============================================================================
function usage ()
{
	echo "Usage :  $0 [options] [--]

    Options:
    -h|help       Display this message
    -v|version    Display script version"

}    # ----------  end of function usage  ----------

#-----------------------------------------------------------------------
#  Handle command line arguments
#-----------------------------------------------------------------------

KVM_DISK="/export/disk1T/kvm/normal_debug/centos8.qcow2"
KVM_NVME=""
KVM_CMD=""
PCI_BUS_ID=""
KVM_EXARGS="-enable-kvm -cpu host -smp 8 -m 8192 --nographic  -drive driver=qcow2,media=disk,cache=writeback,if=virtio,id=me_rootfs,file=${KVM_DISK}  -netdev tap,id=hostnet0,vhost=on -device virtio-net-pci,netdev=hostnet0,id=net0,mac=52:54:00:56:c9:63"

function init_run_env() {
if [ -f /usr/bin/qemu-system-x86_64 ]
then
	KVM_CMD="/usr/bin/qemu-system-x86_64 "
elif [ -f  /usr/libexec/qemu-kvm ]
then
	KVM_CMD="/usr/libexec/qemu-kvm "
else
	die "qemu-kvm or qemu-system-x86_64 not find"
fi
}

init_run_env

while getopts ":hvnf:" opt
do
  case $opt in

	h|help    )  usage; exit 0   ;;
	n|nvme     )
		qemu-kvm -enable-kvm -m 2048 -smp 1 /path/to/vm.qcow2 -boot c 
		KVM_EXARGS=`echo $KVM_EXARGS   -drive file=/export/disk1T/kvm/normal_debug/nvme.img,if=none,id=D22 -device nvme,drive=D22,serial=1234`
		 ;;
	f|vfio     )
		PCI_BUS_ID=$OPTARG
		modprobe vfio-pc
		lspci -n -s 04:00.0
		echo "0000:04:00.0" > /sys/bus/pci/devices/0000\:04\:00.0/driver/unbind
		echo "8086 2522" > /sys/bus/pci/drivers/vfio-pci/new_id
		KVM_EXARGS=$KVM_EXARGS + " -device vfio-pci,host=04:00.0,id=nvme "
		 ;;

	v|version  )  echo "$0 -- Version $__ScriptVersion"; exit 0   ;;

	* )  echo -e "\n  Option does not exist : $OPTARG\n"
		  usage; exit 1   ;;

  esac    # --- end of case ---
done
shift $(($OPTIND-1))

${KVM_CMD} ${KVM_EXARGS}
#qemu-system-x86_64 -enable-kvm -cpu host -smp 2 -m 8192 --nographic  -drive driver=qcow2,media=disk,cache=writeback,if=virtio,id=me_rootfs,file=/home/zc/work/qemu/centosv2.qcow2 -net nic -net tap,ifname=tap0,script=/etc/qemu-ifup



#qemu-system-x86_64 -enable-kvm -cpu host -smp 2 -m 8192 --nographic  -drive driver=qcow2,media=disk,cache=writeback,if=virtio,id=me_rootfs,file=/home/zc/work/qemu/centos7.qcow2 -net nic -net tap,ifname=tap0,script=/etc/qemu-ifup
#qemu-system-x86_64 -enable-kvm -cpu host -bios /usr/share/ovmf/OVMF.fd -smp 2 -m 8192 --nographic  -drive driver=qcow2,media=disk,cache=writeback,if=virtio,id=me_rootfs,file=/home/zc/work/qemu/centosv2.qcow2 -net nic -net tap,ifname=tap0,script=/etc/qemu-ifup
#qemu-system-x86_64 -enable-kvm -cpu host -bios /usr/share/ovmf/OVMF.fd -smp 2 -m 8192 --nographic  -drive driver=qcow2,media=disk,cache=writeback,if=virtio,id=me_rootfs,file=/home/zc/work/qemu/centos7.qcow2 -netdev tap,id=tapnet,ifname=tap0,script=no  -device rtl8139,netdev=tapnet
#qemu-system-x86_64 -enable-kvm -cpu host -bios /usr/share/ovmf/OVMF.fd -smp 2 -m 8192 --nographic  -drive driver=qcow2,media=disk,cache=writeback,if=virtio,id=me_rootfs,file=/home/zc/work/qemu/centos7.qcow2 -netdev tap,id=tapnet,ifname=tap0,script=no  -device rtl8139,netdev=tapnet
#qemu-system-x86_64 -enable-kvm -cpu host -bios /usr/share/ovmf/OVMF.fd -smp 2 -m 8192 --nographic  -drive driver=qcow2,media=disk,cache=writeback,if=virtio,id=me_rootfs,file=/home/zc/work/qemu/centos7.qcow2 -netdev user,id=n1,hostfwd=tcp::5555-:22  -device virtio-net-pci,netdev=n1
#qemu-system-x86_64 -enable-kvm -cpu host -bios /usr/share/ovmf/OVMF.fd -smp 2 -m 8192 -drive driver=qcow2,media=disk,cache=writeback,if=virtio,id=me_rootfs,file=/home/zc/work/qemu/centos7.qcow2
#qemu-kvm -cpu host  -M virt,gic-version=3  -smp 8 -m 8192    -cpu host  -bios /usr/share/AAVMF/AAVMF_CODE.fd -nographic   -drive driver=qcow2,media=disk,cache=writeback,if=virtio,id=alinu1_rootfs,file=/data/zc/qcow2/shenlong.qcow2 -netdev user,id=n1,hostfwd=tcp::5555-:22  -device virtio-net-pci,netdev=n1
#qemu-system-x86_64  -serial mon:stdio --nographic  -drive driver=qcow2,media=disk,cache=writeback,if=virtio,id=me_rootfs,file=/home/zc/work/qemu/centos7.qcow2
