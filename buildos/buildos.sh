#!/bin/bash

curdir=`pwd`
myspace=$curdir
buildos_root=$curdir/buildos
CENTOSVER=""
OPENEULERVER=""

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
__ScriptVersion="1.0"

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

while getopts ":hvco" opt
do
  case $opt in

	h|help     )  usage; exit 0   ;;

	v|version  )  echo "$0 -- Version $__ScriptVersion"; exit 0   ;;

	c|centos_version ) 
		CENTOSVER=$OPTAGR
		;;
	o|openeuler_version ) 
		OPENEULERVER=$OPTAGR
		;;

	* )  echo -e "\n  Option does not exist : $OPTARG\n"
		  usage; exit 1   ;;

  esac    # --- end of case ---
done
shift $(($OPTIND-1))

umount $buildos_root/dev
umount $buildos_root/proc
rm -rf  $buildos_root     > /dev/null
rm -f  *.rpm > /dev/null

[[ -d $buildos_root ]] && rm -fr $buildos_root && mkdir -p $buildos_root

function centosbuild() {
	rpm --root $buildos_root --initdb
	wget https://vault.centos.org/centos/8.2.2004/BaseOS/x86_64/os/Packages/centos-release-8.2-2.2004.0.1.el8.x86_64.rpm
	wget https://vault.centos.org/centos/8.2.2004/BaseOS/x86_64/os/Packages/centos-gpg-keys-8.2-2.2004.0.1.el8.noarch.rpm
	wget https://vault.centos.org/centos/8.2.2004/BaseOS/x86_64/os/Packages/centos-repos-8.2-2.2004.0.1.el8.x86_64.rpm
	#wget https://vault.centos.org/centos/8.2.2004/BaseOS/x86_64/os/Packages/centos-gpg-keys-8.2-1.2004.0.2.el8.noarch.rpm
	#wget https://vault.centos.org/centos/8.2.2004/BaseOS/x86_64/os/Packages/centos-repos-8.2-1.2004.0.2.el8.x86_64.rpm
	#yumdownloader centos-release

	if [ $? -ne 0 ]
	then
		echo "Error: download centos-release failed"
		exit 1
	fi

	rpm --root $buildos_root -ivh centos-release* centos-gpg-keys* centos-repos*
	rm *.rpm -f
}

function openeulerbuild() {
	rpm --root $buildos_root --initdb
	wget https://repo.openeuler.org/openEuler-22.03-LTS/OS/x86_64/Packages/openEuler-release-22.03LTS-52.oe2203.x86_64.rpm
	wget https://repo.openeuler.org/openEuler-22.03-LTS/OS/x86_64/Packages/openEuler-repos-1.0-3.4.oe2203.x86_64.rpm
	wget https://repo.openeuler.org/openEuler-22.03-LTS/OS/x86_64/Packages/openEuler-gpg-keys-1.0-3.4.oe2203.x86_64.rpm

	if [ $? -ne 0 ]
	then
		echo "Error: download centos-release failed"
		exit 1
	fi

	rpm --root $buildos_root -ivh *.rpm --nodepp
	rm *.rpm
}

openeulerbuild
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

