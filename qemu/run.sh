
#qemu-system-x86_64 -enable-kvm -cpu host -smp 2 -m 8192 --nographic  -drive driver=qcow2,media=disk,cache=writeback,if=virtio,id=me_rootfs,file=/home/zc/work/qemu/centos7.qcow2 -net nic -net tap,ifname=tap0,script=/etc/qemu-ifup

qemu-system-x86_64 -enable-kvm -cpu host -smp 2 -m 8192 --nographic  -drive driver=qcow2,media=disk,cache=writeback,if=virtio,id=me_rootfs,file=/home/zc/work/qemu/centosv2.qcow2 -net nic -net tap,ifname=tap0,script=/etc/qemu-ifup

#qemu-system-x86_64 -enable-kvm -cpu host -bios /usr/share/ovmf/OVMF.fd -smp 2 -m 8192 --nographic  -drive driver=qcow2,media=disk,cache=writeback,if=virtio,id=me_rootfs,file=/home/zc/work/qemu/centosv2.qcow2 -net nic -net tap,ifname=tap0,script=/etc/qemu-ifup

#qemu-system-x86_64 -enable-kvm -cpu host -bios /usr/share/ovmf/OVMF.fd -smp 2 -m 8192 --nographic  -drive driver=qcow2,media=disk,cache=writeback,if=virtio,id=me_rootfs,file=/home/zc/work/qemu/centos7.qcow2 -netdev tap,id=tapnet,ifname=tap0,script=no  -device rtl8139,netdev=tapnet

#qemu-system-x86_64 -enable-kvm -cpu host -bios /usr/share/ovmf/OVMF.fd -smp 2 -m 8192 --nographic  -drive driver=qcow2,media=disk,cache=writeback,if=virtio,id=me_rootfs,file=/home/zc/work/qemu/centos7.qcow2 -netdev tap,id=tapnet,ifname=tap0,script=no  -device rtl8139,netdev=tapnet

#qemu-system-x86_64 -enable-kvm -cpu host -bios /usr/share/ovmf/OVMF.fd -smp 2 -m 8192 --nographic  -drive driver=qcow2,media=disk,cache=writeback,if=virtio,id=me_rootfs,file=/home/zc/work/qemu/centos7.qcow2 -netdev user,id=n1,hostfwd=tcp::5555-:22  -device virtio-net-pci,netdev=n1
#qemu-system-x86_64 -enable-kvm -cpu host -bios /usr/share/ovmf/OVMF.fd -smp 2 -m 8192 -drive driver=qcow2,media=disk,cache=writeback,if=virtio,id=me_rootfs,file=/home/zc/work/qemu/centos7.qcow2


#qemu-kvm -cpu host  -M virt,gic-version=3  -smp 8 -m 8192    -cpu host  -bios /usr/share/AAVMF/AAVMF_CODE.fd -nographic   -drive driver=qcow2,media=disk,cache=writeback,if=virtio,id=alinu1_rootfs,file=/data/zc/qcow2/shenlong.qcow2 -netdev user,id=n1,hostfwd=tcp::5555-:22  -device virtio-net-pci,netdev=n1
#qemu-system-x86_64  -serial mon:stdio --nographic  -drive driver=qcow2,media=disk,cache=writeback,if=virtio,id=me_rootfs,file=/home/zc/work/qemu/centos7.qcow2
