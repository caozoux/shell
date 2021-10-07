#!/bin/bash
set -x

function passwd_config()
{
passwd << EOF
123
123
EOF
}

function ssh_config() {
	mkdir etc/ssh
	mkdir var/empty/sshd -p
	cp ../ssh/* etc/ssh
	cp /lib64/libfipscheck.so.1* lib64/
	cp /lib64/libnsl*  lib64/
	cp /lib64/libutil*  lib64/
	cp /lib64/libwrap.so.0* lib64/
	echo "sshd:x:74:74:Privilege-separated SSH:/var/empty/sshd:/sbin/nologin" >> etc/passwd
	cp /usr/sbin/sshd usr/sbin/
	cp /usr/sbin/sshd usr/sbin/
	cp /usr/bin/scp usr/bin/
	#function_body
}

function die() {
	echo "Die $1"
	exit 1
}

__ScriptVersion="version"

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

BUSYBOX_DIR=""
INITRAMFS=""
BUSYBOX_WORKDIR="`pwd`/./busybox_workdir"

#-----------------------------------------------------------------------
#  Handle command line arguments
#-----------------------------------------------------------------------

while getopts ":hvb:i:" opt
do
  case $opt in

	h|help     )  usage; exit 0   ;;
	b|busboxdir     )
		BUSYBOX_DIR=$OPTARG
		;;
	i|initramfs     )
		INITRAMFS=$OPTARG
		;;

	v|version  )  echo "$0 -- Version $__ScriptVersion"; exit 0   ;;

	* )  echo -e "\n  Option does not exist : $OPTARG\n"
		  usage; exit 1   ;;

  esac    # --- end of case ---
done
shift $(($OPTIND-1))

[ -d $BUSYBOX_DIR/_install ] || die "$BUSYBOX_DIR/_install no find"

[ -f $INITRAMFS ] || die "$INITRAMFS no find"


if [ -d $BUSYBOX_WORKDIR ]
then
	rm $BUSYBOX_WORKDIR/* -rf
else
	mkdir -f $BUSYBOX_WORKDIR
fi
cp $INITRAMFS $BUSYBOX_WORKDIR && cd $BUSYBOX_WORKDIR; mv $INITRAMFS $INITRAMFS.gz ; gunzip $INITRAMFS.gz ; cpio -iF $INITRAMFS 

cd $BUSYBOX_DIR/_install && tar cpzf $BUSYBOX_WORKDIR/busbox.tar.gz *
cd $BUSYBOX_WORKDIR ; tar pxf busbox.tar.gz

mkdir  etc/init.d/
cp ../rc.sysinit  etc/init.d/rcS
rm init
ln -s bin/busybox init
ssh_config
passwd_config

find . | cpio -c -o >  ../initramfs_busbox.img

#chmod +x etc/init.d/rcS
