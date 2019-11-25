#!/bin/bash
virt-install  \
--name alios7-vm \
--ram 20480 \
--disk path=/export/disk1T/zoucao.zcdisk/kvm/alios7-ali3000.img,size=100   \
--vcpus 10   \
--os-type linux  \
--os-variant rhel6   \
--network bridge=virbr0   \
--graphics none   \
--console pty,target_type=serial   \
--location "http://mirrors.163.com/centos/7/os/x86_64" \
--extra-args "console=ttyS0,115200n8 serial"



#--location "http://mirrors.163.com/centos/7.5.1804/os/x86_64" \
#--location "http://vault.centos.org/6.4/os/x86_64/" \
