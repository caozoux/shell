#!/bin/bash


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
    -c|create     create qcow2 file, such as qemu-img create -f qcow2 test.qcow2 10G
    -m|mount 	  mount qcow2 file to /mnt, such as qemu-img create -f qcow2 test.qcow2 10G
    -v|version    Display script version"

}    # ----------  end of function usage  ----------

function mout_qcow2() {
	if [ ! -f $1 ]
	then
		echo "$1 file not exist"
		exit 1
	fi
	modprobe nbd max_part=63
	qemu-nbd -c /dev/nbd0 $1
	#function_body
}
#-----------------------------------------------------------------------
#  Handle command line arguments
#-----------------------------------------------------------------------

while getopts ":hvcm:" opt
do
  case $opt in

	h|help     )  usage; exit 0   ;;
	m|mount    )
		mout_qcow2 $OPTARG
		exit 0
		break ;;

	v|version  )  echo "$0 -- Version $__ScriptVersion"; exit 0   ;;

	* )  echo -e "\n  Option does not exist : $OPTARG\n"
		  usage; exit 1   ;;

  esac    # --- end of case ---
done
shift $(($OPTIND-1))
