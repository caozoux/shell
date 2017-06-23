#!/bin/bash

function add_upsteeam_commit() {
	patchname=$1
	#upstram_commit=`sed -n "$patchname" $1 | sed -n 's/From \(.\{40\}\).*/\1/p'`
	upstram_commit=`sed -n "1p" $patchname | sed -n 's/From \(.\{40\}\).*/\1/p'`
	loop=1
	linenumber=3
	line=""
	while [ $loop ]
	do
		line=`sed -n "${linenumber}p" $patchname`

		if [ $? == 1 ]
		then
			break
		fi

		if [ "$line" == "" ]
		then
			sed -i "$linenumber aupstream $upstram_commit commit\n" $patchname
			break
		fi
		linenumber=`expr $linenumber + 1` 
	done
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
    -v|version    Display script version
    -s            upstream git dir
    -d            patch dir"

}    # ----------  end of function usage  ----------

#-----------------------------------------------------------------------
#  Handle command line arguments
#-----------------------------------------------------------------------

UPSTREAM_SHORTLOG=""
UPSTREAM_DIR=""
PATH_DIR=""
CUR_DIR=`pwd`
while getopts ":hvs:d:" opt
do
  case $opt in

	h|help     )  usage; exit 0   ;;

	v|version  )  echo "$0 -- Version "; exit 0   ;;

	s 		   )  UPSTREAM_SHORTLOG=$OPTARG; echo $OPTARG;;
	d          )  PATH_DIR=$OPTARG; UPSTREAM_DIR=`dirname $UPSTREAM_SHORTLOG`;;
	* )  echo -e "\n  Option does not exist : $OPTARG\n"
		  usage; exit 1   ;;

  esac    # --- end of case ---
done
shift $(($OPTIND-1))

~/bin/patchTool.py -j4 -e -s $UPSTREAM_SHORTLOG -d $PATH_DIR | grep findpatch |
while read line
do
	replace_patch=`echo $line | cut -d : -f 4|sed 's/^[ ]//g'`
	commitid=`echo $line | cut -d : -f 2`
	patchname=`git -C $UPSTREAM_DIR format-patch -1 $commitid -o $CUR_DIR`
	echo $patchname
#	add_upsteeam_commit $patchname
	echo "replace $PATH_DIR/$replace_patch with $patchname"
	mv $patchname $PATH_DIR/$replace_patch
done
