#!/bin/bash
set -x

__ScriptVersion="1.0"

function die()
{
	echo "$1"
	exit 1
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
    -v|version    Display script version"

}    # ----------  end of function usage  ----------

#-----------------------------------------------------------------------
#  Handle command line arguments
#-----------------------------------------------------------------------
KERNEL_PATH=""
KERNEL_VERSION=""
KERNEL_EXTRA=""
RPMDIR="`pwd`/rpmbuild"

while getopts ":hvk:n:e:" opt
do
  case $opt in

	h|help     )  usage; exit 0   ;;

	k|kernel   )
		KERNEL_PATH=$OPTARG
		;;
	n|version  )
		KERNEL_VERSION=$OPTARG
		;;
	e|extar   )
		KERNEL_EXTRA=$OPTARG
		;;

	v|version  )  echo "$0 -- Version $__ScriptVersion"; exit 0   ;;

	* )  echo -e "\n  Option does not exist : $OPTARG\n"
		  usage; exit 1   ;;

  esac    # --- end of case ---
done
shift $(($OPTIND-1))

if [ ! -d ${RPMDIR} ]
then
	mkdir ${RPMDIR}
	mkdir ${RPMDIR}/BUILD 
	mkdir ${RPMDIR}/BUILDROOT
	mkdir ${RPMDIR}/RPMS
	mkdir ${RPMDIR}/SOURCES
	mkdir ${RPMDIR}/SPECS
	mkdir ${RPMDIR}/SRPMS
fi

if [ ! ${KERNEL_PATH}   ]
then
	die "KERNEL_PATH is NULL"		
fi

if [ ! $KERNEL_EXTRA  ]
then
	die "KERNEL_EXTRA is NULL"		
fi

if [ ! $KERNEL_VERSION ]
then
	VERSION=`cat $KERNEL_PATH/Makefile | grep "^VERSION =" | awk '{print $3}'`
	PATCHLEVEL=`cat $KERNEL_PATH/Makefile | grep "^PATCHLEVEL =" | awk '{print $3}'`
	SUBLEVEL=`cat $KERNEL_PATH/Makefile | grep "^SUBLEVEL =" | awk '{print $3}'`
	KERNEL_VERSION=${VERSION}.${PATCHLEVEL}.${SUBLEVEL}
	#die "KERNEL_VERSION is NULL"		
fi

if [ ! kerenl ]
then
	mkdir kernel
else
	rm -rf kernel
	mkdir kernel
fi

#get linux version

# VERSION=`cat $KERNEL_PATH/Makefile | grep "^VERSION ="`

cp $KERNEL_PATH/* kernel  -rf

tar cf kernel.tar.gz kernel

mv kernel.tar.gz  ${RPMDIR}/SOURCES/

#rpmbuild --rebuild  --define '_topdir ${RPMDIR}' --define '_sourcedir %{_topdir}/SOURCES' --define '_specdir %{_topdir}/SPECS' --define '_srcrpmdir %{_topdir}/SRPMS' --define '_rpmdir %{_topdir}/RPMS'   --without check kernel-rt.spec
rpmbuild -bb   --define "_without_version 1"  --define "kernel_version ${KERNEL_VERSION}" --define "_without_extra 1"  --define "extra_release  .${KERNEL_EXTRA}"  --define "_topdir ${RPMDIR}" --define '_sourcedir %{_topdir}/SOURCES' --define '_specdir %{_topdir}/SPECS' --define '_srcrpmdir %{_topdir}/SRPMS' --define '_rpmdir %{_topdir}/RPMS'   --without check kernel-rt.spec

#rpmbuild --bb  --define "_topdir ${RPMDIR}" --define '_sourcedir %{_topdir}/SOURCES' --define '_specdir %{_topdir}/SPECS' --define '_srcrpmdir %{_topdir}/SRPMS' --define '_rpmdir %{_topdir}/RPMS'   --without check kernel-rt.spec


#rpmbuild --rebuild  --define '_topdir ${RPMDIR}' --define '_sourcedir %{_topdir}/SOURCES' --define '_specdir %{_topdir}/SPECS' --define '_srcrpmdir %{_topdir}/SRPMS' --define '_rpmdir %{_topdir}/RPMS'  --define 'dist %{nil}' --target aarch64 --define '_prefix /usr' --define '_exec_prefix /usr' --define '_sysconfdir /etc' --define '_usr /usr' --without check  --define 'dpdk_datadir /opt/mellanox/dpdk/share' --with dpdk --with static /mnt/work/mlnx_rpms/MLNX_OFED_LINUX-5.4-1.0.3.0-rhel7.6alternate-aarch64/src/MLNX_OFED_SRC-5.4-1.0.3.0/SRPMS/openvswitch-2.14.1-1.54103.src.rpm



