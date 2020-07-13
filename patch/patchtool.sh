#!/bin/bash

__ScriptVersion="1.0"
__Type="mainline"
__CommitMainlineDesc="fix #zzz\ncommit xxx upstream"
__CommitEulorDesc="fix #zzz\n\ncommit xxx openEuler-1.0"
__Commit=""
__Emailname="Signed-off-by: Zou Cao <zoucao@linux.alibaba.com>"
__Format=0
__FixID=0
__Patchname=""

#===  FUNCTION  ================================================================
#         NAME:  usage
#  DESCRIPTION:  Display usage information.
#===============================================================================
function usage ()
{
	echo "Usage :  $0 [options] [--]

    Options:
    -h|help       Display this message
    -m|format     format patch
				  -m -x fixid -f patchname -t [mainline/euler] -> mainline/euler
    -x|fixid      fixid
				  -x aone fixedind
    -v|version    Display script version"

}    # ----------  end of function usage  ----------

#-----------------------------------------------------------------------
#  Handle command line arguments
#-----------------------------------------------------------------------

while getopts ":hvmt:f:x:" opt
do
  case $opt in

	h|help     )  usage; exit 0   ;;

	v|version  )  echo "$0 -- Version $__ScriptVersion"; exit 0   ;;

	m|format  )
		__Format=1
		continue   ;;

	x|fixid )
		__FixID=$OPTARG
		continue   ;;

	t|type )
		__Type=$OPTARG
		continue   ;;

	f|file )
		__Patchname=$OPTARG
		continue   ;;

	* )  echo -e "\n  Option does not exist : $OPTARG\n"
		  usage; exit 1   ;;

  esac    # --- end of case ---
done
shift $(($OPTIND-1))

set -x
if [ $__Format -eq 1 ]
then
	if [ ! -f $__Patchname ]
	then
		echo "$__Patchname not find\n"
		exit 1
	fi

	ID=`sed -n '1p' ${__Patchname}  | awk '{print $2}'`
	if [ "$__Type" == "eulor" ]
	then
		#__Commit=`echo ${__CommitEulorDesc} | sed "s/zzz/${__FixID}/"`
		__Commit=`echo ${__CommitEulorDesc} | sed "s/zzz/${__FixID}/" | sed "s/xxx/${ID}/"`
	fi
	sed -i "s/^Subj.*/&\n\n${__Commit}/" $__Patchname

	if [ $? -ne 0 ]
	then
		echo "foramt $__Patchname failed"
		exit 1
	fi

	sed -i "s/^---$/${__Emailname}\n&/" $__Patchname 
	if [ $? -ne 0 ]
	then
		echo "foramt $__Patchname failed"
		exit 1
	fi
fi
