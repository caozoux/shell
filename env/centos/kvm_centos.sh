#!/bin/bash

yum -y install kvm python-virtinst libvirt-client  libvirt virt-install libvirt-daemon bridge-utils virt-manager qemu-kvm-tools  virt-viewer  virt-v2v libvirt-daemon-driver-*

sudo virt-install  \
--name alios7-vm1   \
--ram 20480   \
--disk path=/home/zoucao.zc/kvm/normal_debug/alios7-vm1.img,size=10   \
--vcpus 10   \
--os-type linux  \
--os-variant rhel7   \
--network bridge=virbr0   \
--graphics none   \
--console pty,target_type=serial   \
--location "http://mirrors.163.com/centos/7.4.1708/os/x86_64" \
--extra-args "console=ttyS0,115200n8 serial"
