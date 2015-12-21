#!/bin/bash
#grep -n "Upstream" -R . | cut -d : -f 1  | while read line; do cat $line | sed -n '4p' | cut -d ] -f 2;done | while read line1; do sed  -n '/${line1}/p' /home/wrsadmin/github/linux-stable/shortlog;done

patch_name[2000]={0}
#S1 path dir
#S2 gitlog
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
fi

if [ -f $2 ]
then
	echo "gitlog: $2"
else
	echo "error: $2 isn't file"
fi

cnt=0
#grep -n "Upstream" -R $1 | cut -d : -f 1 | while read line 
ls $1 | cut -d : -f 1 | while read line 
do
	patch_name[$cnt]=$1/$line
	#patch_name[$cnt]=$line

	pch_commit_name=`sed -n '4p' ${patch_name[$cnt]} | cut -d ] -f 2`
	#echo "try to find $pch_commit_name"
	echo "sed  -n "/${pch_commit_name}/p" $2"
	ret=`sed  -n "/${pch_commit_name}/p" $2`
	echo $ret
	if [ $ret="" ]
	then
		:
	else
		echo "   find ${patch_name[$cnt]} $pch_commit_name in upstream"
	fi
	cnt=`expr $cnt + 1`
done
