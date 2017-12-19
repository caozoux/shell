#!/bin/bash

primary_display=""
extern_display=""

primary_display=`xrandr -q | grep " connected" | cut -d " " -f 1 | sed -n 1p`
extern_display=`xrandr -q | grep " connected" | cut -d " " -f 1 | sed -n 2p`
current_display=`xrandr -q | grep "0+0+0" | cut -d " " -f 1 | sed -n 1p`

__ScriptVersion="version 1.0"

#===  FUNCTION  ================================================================
#         NAME:  cursor_swtich
#  DESCRIPTION:  switch cursor in multiplute monitors
#===============================================================================
function cursor_swtich() {
	if [ "$1" = "left" ]
	then
		python3.4 /folk/czou/github/shell/ubuntuenv/move_cursor_in_screen.py left &&  xdotool  click 1
	elif [ "$1" = "right" ]
	then
		python3.4 /folk/czou/github/shell/ubuntuenv/move_cursor_in_screen.py right &&  xdotool  click 1
	fi
}

function update_display ()
{
	primary_display=`xrandr -q | grep " connected" | cut -d " " -f 1 | sed -n 1p`
	extern_display=`xrandr -q | grep " connected" | cut -d " " -f 1 | sed -n 2p`
	current_display=`xrandr -q | grep "0+0+0" | cut -d " " -f 1 | sed -n 1p`
}

function switch_monitor ()
{
	update_display 
	if [ "$current_display" = "$primary_display" ]
	then
		xrandr --output $extern_display --left-of $primary_display
		python3.4 /folk/czou/github/shell/ubuntuenv/move_cursor_in_screen.py right &&  xdotool  click 1
	else
		xrandr --output $primary_display --left-of $extern_display
		python3.4 /folk/czou/github/shell/ubuntuenv/move_cursor_in_screen.py left &&  xdotool  click 1
	fi
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
    -s|switch     switch display
    -m|move [left/right]      move curcor"

}    # ----------  end of function usage  ----------

#-----------------------------------------------------------------------
#  Handle command line arguments
#-----------------------------------------------------------------------

while getopts ":hvsm:" opt
do
  case $opt in

	h|help     )  usage; exit 0   ;;

	v|version  )  echo "$0 -- Version $__ScriptVersion"; exit 0   ;;
	s|swtich   )
		switch_monitor
		exit 0   ;;
	m|move     )
		echo $2
		cursor_swtich $2
		exit 0   ;;

	* )  echo -e "\n  Option does not exist : $OPTARG\n"
		  usage; exit 1   ;;

  esac    # --- end of case ---
done
shift $(($OPTIND-1))

