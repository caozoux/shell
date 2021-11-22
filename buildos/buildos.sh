#!/bin/bash

curdir=`pwd`
myspace=$curdir
buildos_root=$curdir/buildos

function dockerimages_ssh()
{
	chroot $buildos_root  /usr/bin/yum install -y openssh httpd
}

function dockerimages_net()
{
	chroot $buildos_root  /usr/bin/yum install -y net-tools  bridge-utils ethtool pciutils iptables
}

function centos7_set()
{
	sed -i "s/enforcing/disabled/"/etc/selinux/config
}

function passwd_set()
{
chroot $buildos_root  passwd << EOF
123
123
EOF
}

function mini_os()
{
	systemctl disable rhel-dmesg
	#pv6.conf.all.disable_ipv6=1
	#net.ipv6.conf.default.disable_ipv6 = 1

}
function centos_env_inst()
{
	touch $buildos_root/etc/sysconfig/network
	#chroot $buildos_root  /bin/yum -y groupinstal "Minimal Install"
	chroot $buildos_root  /bin/yum -y install  grub2-tools net-tools kernel kernel-devel kernel-headers
	#mkdir $buildos_root  /boot/grub2

	#grub2 lagcy boot
	chroot $buildos_root  /bin/yum -y install  grub2-pc grub-common

	chroot $buildos_root /bin/sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

	chroot $buildos_root /bin/systemctl disbale auditd
	chroot $buildos_root /bin/systemctl disable NetworkManager
	chroot $buildos_root /bin/systemctl disable postfix
	cp cfg/ifcfg-eth0    $buildos_root/etc/sysconfig/network-scripts/
	cp cfg/fstab         $buildos_root/etc/
}

umount $buildos_root/dev
umount $buildos_root/proc
rm -rf  $buildos_root     > /dev/null
[[ -d $buildos_root ]] && rm -fr $buildos_root && mkdir -p $buildos_root

rpm --root $buildos_root --initdb
yumdownloader centos-release

if [ $? -ne 0 ]
then
	echo "Error: download centos-release failed"
	exit 1
fi

rpm --root $buildos_root -ivh centos-release*
#install yum without docs and install only english language files during the process：
yum -y --installroot=$buildos_root --setopt=tsflags='nodocs' --setopt=override_install_langs=en_US.utf8 install yum yum-plugin-bestyumcache 
#configure yum to avoid installing of docs and other language files than english generally
sed -i "/installonly_limit=5/a override_install_langs=en_US.utf8\ntsflags=nodocs" $buildos_root/etc/yum.conf
#chroot to the environment and install some additional tools：
cp /etc/resolv.conf $buildos_root/etc
#cp /etc/bashrc $buildos_root/root/.bashrc
cp /etc/motd $buildos_root/etc/motd


mount -o bind /dev $buildos_root/dev
mount -o bind /proc $buildos_root/proc
chroot $buildos_root  /bin/yum -y groupinstall "Minimal Install"
dockerimages_net
dockerimages_ssh
centos_env_inst
chroot $buildos_root  /usr/bin/yum clean all
umount $buildos_root/dev
umount $buildos_root/proc
cd $buildos_root
XZ_OPT="--threads=0 -9 --verbose"  tar -cJpf ../baseos.tar.gz *
cd -

