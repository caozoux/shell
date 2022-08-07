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
    -p|pci        pci device id 
    -v|version    Display script version"

}    # ----------  end of function usage  ----------

#-----------------------------------------------------------------------
#  Handle command line arguments
#-----------------------------------------------------------------------

PCI_ID=""

while getopts ":hvp:" opt
do
  case $opt in
	h|help )  
		usage;
		exit 0 ;;

	v|version )
		echo "$0 -- Version $__ScriptVersion";
		exit 0   ;;

	p|pci )
		PCI_ID=$OPTARG
		;;

	* )  echo -e "\n  Option does not exist : $OPTARG\n"
		  usage; exit 1   ;;

  esac    # --- end of case ---
done
shift $(($OPTIND-1))


modprobe vfio-pci

device_id=`lspci -s $PCI_ID -n | awk '{print $3}'`

device_id=${device_id/:/ } #去除：号

echo "PCI: $PCI_ID, Device ID:$device_id"

pci_device=/sys/bus/pci/devices/0000:$PCI_ID/iommu_group/devices/

pci_device=`echo $pci_device | sed 's/:/\\:/g'`
echo "$device_id" > /sys/bus/pci/drivers/vfio-pci/new_id

for dev in `ls $pci_device`
do
	echo "---dev:$dev"
	_pci_dev_unbind="/sys/bus/pci/devices/$dev/driver/unbind"
	_pci_dev_unbind=`echo $_pci_dev_unbind | sed 's/:/\\:/g'`

	#ls $_pci_dev_unbind

	echo "$dev" > $_pci_dev_unbind
	echo "$dev" > /sys/bus/pci/drivers/vfio-pci/bind
	lspci -s $dev -k
done
		
	
