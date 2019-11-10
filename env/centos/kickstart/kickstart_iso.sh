if [ -f /export/disk1T/Downloads/test.raw ]
then
	sudo rm /export/disk1T/Downloads/test.raw -f
	echo "rm files"
fi
qemu-img create -f raw /export/disk1T/Downloads/test.raw 20G

sudo virt-install \
     --name testvm \
     --ram=4096 \
     --vcpus=4 \
     --os-type linux  \
     --location /export/disk1T/Downloads/CentOS-7-x86_64-Minimal-1908.iso \
	 --disk /export/disk1T/Downloads/test.raw,format=raw \
     --network bridge=virbr0 \
     --graphics=none \
     --os-variant="rhel7" \
     --console pty,target_type=serial \
     -x 'console=ttyS0,115200n8 serial' \
     -x "ks=http://192.168.0.105/ks.cfg"
