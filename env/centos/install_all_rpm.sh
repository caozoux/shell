#!/bin/bash


yum install net-tools.x86_64 nfs-utils protmap
yum install vim git
sudo yum install nfs-utils
sudo yum install rpm-build redhat-rpm-config asciidoc hmaccalc perl-ExtUtils-Embed pesign xmlto
sudo yum install rpm-build redhat-rpm-config asciidoc hmaccalc perl-ExtUtils-Embed pesign xmlto
sudo yum install audit-libs-devel binutils-devel elfutils-devel elfutils-libelf-devel
sudo yum install ncurses-devel newt-devel numactl-devel pciutils-devel python-devel zlib-devel bison

yum install wget java-devel bt


systemctl enable nfs-server.service
systemctl start nfs-server.service

