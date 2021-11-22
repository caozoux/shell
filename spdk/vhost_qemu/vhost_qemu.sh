#!/bin/bash


__ScriptVersion="version"
# virtio_blk or scsi
TYPE=""

function die() {
	#function_body
	echo "die: $1"
	exit 1
}

function scsi_create() {
	./scripts/rpc.py vhost_create_scsi_controller --cpumask 0x1 vhost.0 || die "vhost_create_scsi_controller failed"
	./scripts/rpc.py bdev_malloc_create -b Malloc0 128 512 || die "bdev_malloc_create failed"
	./scripts/rpc.py vhost_scsi_controller_add_target vhost.0 1 Malloc0 || die "vhost_scsi_controller_add_target failed"
}

function virtio_create() {
	./scripts/rpc.py bdev_malloc_create -b Malloc1 128 512 || die "bdev_malloc_create failed"
	./scripts/rpc.py vhost_create_blk_controller --cpumask 0x1 vhost.1 Malloc1
	#scripts/rpc.py vhost_create_blk_controller --cpumask 0x1 -r vhost.1 Malloc0
}

#===  FUNCTION  ================================================================
#         NAME:  usage
#  DESCRIPTION:  Display usage information.
#===============================================================================
function usage ()
{
	echo "Usage :  $0 [options] [--]

    Options:
    -h|help       Display this message
    -t|type       virtio_blk or scsi
    -v|version    Display script version"

}    # ----------  end of function usage  ----------

#-----------------------------------------------------------------------
#  Handle command line arguments
#-----------------------------------------------------------------------

while getopts ":hvt:" opt
do
  case $opt in

	h|help     )  usage; exit 0   ;;

	v|version  )  echo "$0 -- Version $__ScriptVersion"; exit 0   ;;

	t|type     )  
		TYPE=$OPTARG
		break   ;;

	* )  echo -e "\n  Option does not exist : $OPTARG\n"
		  usage; exit 1   ;;

  esac    # --- end of case ---
done
shift $(($OPTIND-1))

case "${TYPE}" in
	"virtio_blk")
		virtio_create;
		;;
	"scsi")
		scsi_create;
		;;
	*)
	 usage; exit 1   ;;
esac


