qemu-kvm -cpu host  -M virt,gic-version=3  -smp 8 -m 8192    -cpu host  -bios /usr/share/AAVMF/AAVMF_CODE.fd -nographic    -cdrom  ~/myiso.iso   -drive driver=qcow2,media=disk,cache=writeback,if=virtio,id=alinu1_rootfs,file=fedora.img

qemu-kvm -cpu host  -M virt,gic-version=3  -smp 8 -m 8192    -cpu host  -bios /usr/share/AAVMF/AAVMF_CODE.fd -nographic   -drive driver=qcow2,media=disk,cache=writeback,if=virtio,id=alinu1_rootfs,file=/data/zc/qcow2/shenlong.qcow2 -netdev user,id=n1,hostfwd=tcp::5555-:22  -device virtio-net-pci,netdev=n1


qemu-kvm -cpu host  -M virt,gic-version=3  -smp 8 -m 8192    -cpu host  -bios /usr/share/AAVMF/AAVMF_CODE.fd -nographic   -drive driver=qcow2,media=disk,cache=writeback,if=virtio,id=alinu1_rootfs,file=/root/shenlong.qcow2   -netdev type=tap,id=net0 -device virtio-net-device,netdev=net0,mac=f8:f2:1e:5e:36:55 -mem-path /dev/hugepages -mem-prealloc -numa node,nodeid=0,cpus=0-7,mem=8192 -netdev user,id=n1,hostfwd=tcp::5555-:22
