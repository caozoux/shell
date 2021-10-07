#!/bin/bash

function create_ramdisk() {
	curdir=`pwd`
	#$1 is direcotry 
	if [ ! -d "$1" ]
	then
		return 1
	fi
	cd $1 
	find . | cpio -o -H newc | gzip > ${curdir}/initrd.img		
	#find . | cpio -o -H newc > ${curdir}/initrd.img		
	##gzip ${curdir}/initrd.img
	#gzip ${curdir}/initrd.img.gz initrd
	cd -

	return 0
}

function die() {
	echo "$1"
	exit 1
}

__ScriptVersion="1.0"
INITRAMFS=""
ISCREATE=0

#===  FUNCTION  ================================================================
#         NAME:  usage
#  DESCRIPTION:  Display usage information.
#===============================================================================
function usage ()
{
	echo "Usage :  $0 [options] [--]

    Options:
    -h|help       Display this message
    -v|version    Display script version
    -d|dir        ramdisk directory
    -c|create     create ramdis"
}    # ----------  end of function usage  ----------

#-----------------------------------------------------------------------
#  Handle command line arguments
#-----------------------------------------------------------------------

while getopts ":hvcd:x" opt
do
  case $opt in

	h|help     )  usage; exit 0   ;;

	v|version  )  echo "$0 -- Version $__ScriptVersion"; exit 0   ;;

	c|create   )
		ISCREATE=1
		continue
		;;

	d|dir   )
		INITRAMFS=$OPTARG
		continue
		;;

	x|expormecc  )
		/usr/lib/dracut/skipcpio  initramfs-4.19.91+.img  | zcat | cpio -ivd
		continue
		;;

	* )  echo -e "\n  Option does not exist : $OPTARG\n"
		  usage; exit 1   ;;

  esac    # --- end of case ---
done
shift $(($OPTIND-1))

if [ $ISCREATE -eq 1 ]
then
	create_ramdisk $INITRAMFS
fi

