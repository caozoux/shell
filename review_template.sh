#!/bin/bash
ID="[US68643]"
Title="" 
Titile_summary=""
#type:
#  kernel code 
#  configuration files
type="kernel code"
board_name="fsl-ls10xx"
reviewer=kexin

function get_patch_commit()
{
	start_commit="6"
	end_commit=`cat $1 | grep -n "\-\-\-$" | cut -d : -f 1`
	if [ -f $1 ]
	then
		title_name2=`sed -n '5p' $1`
		if [ "$title_name2" != "" ]
		then
			start_commit=`expr $start_commit + 1`
		fi
	else
		echo "error $1 not find"
	fi
	end_commit=`sed -n ''$start_commit','$end_commit'p' $1 | grep -n "^$" | cut -d : -f 1`
	end_commit=`expr $start_commit + $end_commit - 1`
	result=`sed -n ''$start_commit','$end_commit'p' $1`
}

function get_patch_modify_files()
{
	start_commit=`cat $1 | grep -n "\-\-\-$" | cut -d : -f 1`
	start_commit=`expr $start_commit + 1`

	end_commit=`cat $1 | sed '1,'$start_commit'd' | grep -n "^$" -num 1 | cut -d : -f 1`
	end_commit=`expr $start_commit + $end_commit`
	echo $start_commit $end_commit
	result=`sed -n ''$start_commit','$end_commit'p' $1`
	return result
}

function generate_review()
{
	review_src="/fslink/ti/kernel-3.14.x"
	patch_cnt="0"
	work_dir=/fslink/review/
	old_review=""
	dir_name=""

	echo -e " 1: src: $review_src \n 2: patchcnt: $patch_cnt \n 3: workdir: $work_dir \n 4: old_review: $old_review \n 5: dir_name: default\n"

	while [ 1 ]
	do
		read -p "are you sure?(Y/n):"  answer
		if [ $answer = "y" ]
		then
			break
		else
			while [ 1 ]
			do
				read -p "which item you need modify?(1~5 or n):"  answer
				if [ $answer = "1" ]
				then
					read review_src
				elif [ $answer == "2" ]
				then
					read patch_cnt
				elif [ $answer == "3" ]
				then
					read work_dir
				elif [ $answer == "4" ]
				then
					read old_review
				elif [ $answer == "5" ]
				then
					read dir_name
				else
					break
				fi
			done
		fi
	done
	if [ $dir_name ="" ]
	then
		dir_name=`date "+%Y-%m-%d"`
	else
		data_var=`date "+%Y-%m-%d"`
		dir_name=$data_var"-"$dir_name
	fi
	if [ -d $work_dir$dir_name"_V1" ]
	then
		read -p "$dir_name is exist, do you want to create V2[y/n]" answer
		#创建V1or V2 review 目录
		if [ $answer = "y" ]
		then
			dir_name=$dir_name"_V2"
			dir_name=$work_dir$dir_name
			old_review=$dir_name
			mkdir $dir_name
		else
			exit
		fi
	else
			dir_name=${work_dir}${dir_name}"_V1"
			mkdir  $dir_name
	fi
	#Tilte
	sed -i '1 s/$/ '${ID}':/' rr
	#reviewer
	sed -i '5 s/$/ '$reviewer'/' rr
	#set kernel code
	if [ "$type" = "kernel code" ]
	then
		sed -i '21 s/n$/y/' rr
	else
		:
	fi

	#board
	sed -i '61 s/n/y/' rr
	sed -i '61 s/$/       '$board_name'/' rr


	#change the rr title and summary context
	title_name=""
	if [ "$patch_cnt" != "0" ]
	then
		cd $review_src & git format-patch -$patch_cnt -o $dir_name |
		while read line
		do
			echo $line
			title_name1=`sed -n '4p' $line  | cut -b 18-`
			title_name2=`sed -n '5p' $line`
			if [ "$title_name2" = "" ]
			then
				title_name=$title_name1
			else
				title_name=$title_name1$title_name2
			fi
			sed -i "1 s/$/ $title_name/" rr
			sed -i "3 s/$/ $title_name/" rr
			#change the rr commit

			break
		done
	fi

	echo -e " 1: $review_src \n 2: patchcnt: $patch_cnt \n 3: workdir: $work_dir \n 4: old_review: $old_review \n 5: dir: $dir_name\n"
	rm -rf  $dir_name
	exit
}


#get_patch_commit $1
get_patch_modify_files $1
