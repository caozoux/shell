#!/bin/bash

DEFAUL_DIR="/sys/kernel/debug/tracing"

#0 or 1 control trace
function trace_en()
{
	TRACE_EN="$DEFAUL_DIR/tracing_on"
	if [ "$1" == 0 ]
	then
		echo 0 > $TRACE_EN
	else
		echo 1 > $TRACE_EN
	fi
}

#clear trace buffer
function trace_clear()
{
	TRACE_CLEAR="$DEFAUL_DIR/trace"
	echo "" > $TRACE_CLEAR
}

#set trace mode
function trace_mode()
{
	TRACE_MODE="$DEFAUL_DIR/current_trace"
	case $1 in
		"hwlat")
			;;
		"blk")
			;;
		"function")
			;;
		"function_graph")
			;;
		"wakeup_dl")
			;;
		"wakeup_rt")
			;;
		"wakeup")
			;;
		"nop")
			;;
		*    )
			echo "Error: trace mode error"
			return
			;;
	esac

	echo $1 > TRACE_MODE
}

#args: file_name
function enable_functions() {
	TRACE_FUNC_FILTER="$DEFAUL_DIR/set_ftrace_filter"
	echo "" > $TRACE_FUNC_FILTER
	if [ -f $1 ]
	then
		cat $1 |
		while read line
		do
			echo $line >> $TRACE_FUNC_FILTER
		done
	fi

	#function_body
}

function trace_init() {
	trace_en 0
	trace_clear
	trace_mode "nop"
	trace_en 1
	#function_body
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

while getopts ":hvf" opt
do
  case $opt in

	h|help     )  usage; exit 0   ;;

	v|version   )  echo "$0 -- Version $__ScriptVersion"; exit 0   ;;
	f|functions )
			
		  exit 0   ;;

	* )  echo -e "\n  Option does not exist : $OPTARG\n"
		  usage; exit 1   ;;

  esac    # --- end of case ---
done
shift $(($OPTIND-1))


