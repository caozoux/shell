#!/bin/sh

curdir=`pwd`
myspace=$curdir
buildos_root=$curdir/buildos

umount $buildos_root/dev
umount $buildos_root/proc
rm -rf  $buildos_root     > /dev/null
rm -rf  $myspace/*.rpm*  > /dev/null
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
chroot $buildos_root  /bin/yum -y install util-linux kernel
chroot $buildos_root  /usr/bin/yum clean all
#chroot $buildos_root  /usr/bin/yum makecache
umount $buildos_root/dev
umount $buildos_root/proc

