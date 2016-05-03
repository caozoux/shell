#!/bin/bash

function patch_has_merged()
{
	patch_name=$1
	pch_commit_name=`sed -n '4p' ${patch_name} | cut -d ] -f 2-`
	echo commit $pch_commit_name
	pch_commit_name=${pch_commit_name//\\/\\\\};
	pch_commit_name=${pch_commit_name//\//\\/};
	pch_commit_name=${pch_commit_name//\[/\\[};
	pch_commit_name=${pch_commit_name//\]/\\]};
	pch_commit_name=${pch_commit_name//\*/\\*};
	echo "                sed  -n \"/${pch_commit_name}/p\" $2"
	ret=`sed  -n "/${pch_commit_name}/p" $2`
	echo "                $ret"

	if [ "$ret" == "" ]
	then
		:
		return 1
	else
		echo "find ${patch_name} "
		return 0
	fi
}

# arg1: patch dir
# arg2: cnt to merge
function merge_patch()
{
	cnt=0
	ls $1/*.patch |
	while read line
	do
		patch_has_merged $line $3
		if [ $? -eq 0 ]
		then
			echo "$line has merge"
			mv $line merge
			cnt=`expr $cnt + 1`
			if [ $cnt == $2 ]
			then
				break
			fi
			continue
		fi

		git am $line
		if [ $? -eq 0 ]
		then
			mv $line handle
		else
			echo "$line merge failed"
			break;
		fi

		cnt=`expr $cnt + 1`
		if [ $cnt == $2 ]
		then
			break
		fi
	done
}

merge_patch $1 $2 shortlog

