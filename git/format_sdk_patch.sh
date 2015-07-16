#!/bin/bash 

if [ $# != 2 ]
then
	echo "error: command is wrong"
	echo " for example: $0 patch_dir gitlog_name"
	exit
fi

if [ -d $1 ]
then
	echo "path: $1"
else
	echo "error: $1 isn't directory"
	exit
fi

if [ "$2"="" ]
then
	echo "format context: $2"
else
	echo "error: format context is null"
	exit
fi

function is_patch_upstream()
{
	fun_ret=`cat $1 | grep "[Uu]pstream"`
	if [ -n "$fun_ret" ]
	then
		return 1
	else
		return 0
	fi
}

#判断这个patch是否已经添加了title
function is_patch_handle()
{
	fun_ret=`cat $1 | grep "cao.zou@windriver.com"`
	if [ -n "$fun_ret" ]
	then
		return 1
	else
		return 0
	fi
}

cnt=0
ls $1/*.patch |
while read line
do
	patch_name[$cnt]=$line
	$(is_patch_upstream  ${patch_name[$cnt]})

	if [ $? -gt 0 ]
	then
		echo "${patch_name[$cnt]} upstream"
		continue
	fi

	$(is_patch_handle ${patch_name[$cnt]})
	if [ $? -gt 0 ]
	then
		echo "${patch_name[$cnt]} has been handle"
		continue
	fi

	line4=`cat ${patch_name[$cnt]} | grep -n "^\-\-\-$" | cut -d : -f 1`
	echo ${patch_name[$cnt]} $line4
	#sed -i '5 i[zou:Original patch taken from\nhttps://github.com/raspberrypi/linux.git rpi-3.18.y]\nSigned-off-by: zou cao <cao.zou@windriver.com>\n' 00
	sed -i "$line4 i$2" ${patch_name[$cnt]}
	echo "handle ${patch_name[$cnt]} with $2"

	cnt=`expr $cnt + 1`
done

exit

ls $1/*.patch |
while read line
do
	patch_name[$cnt]=$line
	line4=`sed -n '4p' ${patch_name[$cnt]} | cut -d ] -f 2`
	line5=`sed -n '5p' ${patch_name[$cnt]}`
	echo l4 $line4 l5 $line5

	if [ -n "$line5" ]
	then

		echo "${patch_name[$cnt]} l5 : $line5"
		echo "try to line6"
		sed -n '6p' ${patch_name[$cnt]}
	fi

	cnt=`expr $cnt + 1`

done
