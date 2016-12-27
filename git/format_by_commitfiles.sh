#!/bin/bash 

function help() {
	echo "$commitfiles $onelineshorlog"
}

if [ $# == 1 ]
then
	echo "err: no args"
fi

if [ "$1" == "-h" ]
then
	help
fi

if [ -d "errlog" ]
then
	pass
else
	mkdir errlog
fi

if [! -d "errlog" ]
then
	mkdir errlog
fi

errlog="errlog/"`date +"%d_%y_%H_%M"`
patchDir="patchdir/"`date +"%d_%y_%H_%M"`
echo "log file: ${errlog}"
touch $errlog
mkdir $patchDir

if [ -f "$1" ] && [ -f "$2" ]
then
	cat $1 |
	while read line
	do
		echo $line
		line=`echo "${line}" | sed 's:[]\[\^\$\.\*\/]:\\\\&:g'`
		#try to find the commit number and commit
		number=`sed -n "/${line}/=" $2`
		number=`echo ${number} | sed  -e "s/[[:space:]].*$//"`
		if [ $? == "0" ]
		then
			if [ "${number}" == "" ]
			then
				echo "err: $line not find"
				echo "${line}" >> ${errlog}
			fi

			echo $number 
			commit=`sed -n "/${line}/p" $2 | sed -n 1p | sed  -e "s/[[:space:]].*$//"`
			#commit=`echo "${commit}" | sed  -e "s/[[:space:]].*$//"`
			echo $commit

			#start format patch
			patch=`git -C $3 format-patch -1 --start-number ${number} ${commit}`
			if [ $? != "0" ]
			then
				echo "${line} format error" >> ${errlog}
			else
				echo  "patch: ${patch}"
				#echo $3/${patch} ${patchDir}/
				mv $3/${patch} ${patchDir}/
			fi
		else
			echo "err: $line not find"
			echo "${line}" >> ${errlog}
		fi
	done
fi

