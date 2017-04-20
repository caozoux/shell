#!/bin/bash
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
    -v|version    Display script version
    -p|patchdir   patches dir
    -o|out 		  split these patches to outdir"

	echo "For example:
		$0 -p patchdir -b 20: 
			split patches in patchdir to 20 blocks"
}    # ----------  end of function usage  ----------

#-----------------------------------------------------------------------
#  Handle command line arguments
#-----------------------------------------------------------------------

arg_patchdir=""
arg_outdir=0
while getopts ":hvp:o:" opt
do
  case $opt in

	h|help     )  usage; exit 0   ;;
	v|version  )  echo "$0 -- Version $__ScriptVersion"; exit 0   ;;
	p|patchdir )  echo "patchdir is:$OPTARG"
		arg_patchdir=$OPTARG	
		;;
	o|out)  echo "out dir is:$OPTARG"
		arg_outdir=$OPTARG	
		;;
	* )  echo -e "\n  Option does not exist : $OPTARG\n"
		  usage; exit 1   ;;

  esac    # --- end of case ---
done
shift $(($OPTIND-1))
patches_cnt=`ls $arg_patchdir/*.patch |wc -l`
read -p "total patches:$patches_cnt   how many blocks do you want to split:" answer 

if [ $answer > 0 ]
then
	split_cnt=$answer
	if [ -d $arg_outdir ]
	then
		read -p "$arg_outdir is exist, remove it y/n?" answer 
		if [ "$answer" == "y" ]
		then
			rm $arg_outdir -rf
			mkdir $arg_outdir
		else
			exit
		fi	
	else
		mkdir $arg_outdir
	fi
	cnt=0
	while [[ $cnt -lt $patches_cnt ]]; do
		mini_cnt=`expr $cnt + 1`
		mini_cnt=`printf "%04d" $mini_cnt`
		cnt=`expr $cnt + $split_cnt`
		max_cnt=`printf "%04d" $cnt`
		mkdir $arg_outdir/${mini_cnt}_to_$max_cnt
		ls $arg_patchdir/*.patch | sed -n "${mini_cnt},${cnt}p" | xargs -i cp {} $arg_outdir/${mini_cnt}_to_$max_cnt
	done
fi
