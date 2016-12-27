#!/bin/bash

if [ -d "$1" ]
then
	:
else
	echo "Err: $1 isn't exits"
	exit
fi


echo "1. sort patch form min to max"
echo "2. sort patch form max to min"
read -p "   select:" answer 
if [ "$answer" == "1" ]
then
	 index=1; 
	 number="0001"; 
	 ls $1/ | sort -g | 
	 while read line 
	 do 
		 newpatch=`echo $line | sed s/[0-9]*-/${number}-/`;
		 index=`expr $index + 1`; 
		 number=`echo $index | awk '{printf("%04d\n",$1)}'`;
		 mv $1/$line  $1/$newpatch
	 done
elif [ "$answer" == "2" ]
then
	 index=1; 
	 number="0001"; 
	 ls $1/ | sort -g -r | 
	 while read line
	 do 
		 newpatch=`echo $line | sed s/[0-9]*-/${number}-/`
		 index=`expr $index + 1`
		 number=`echo $index | awk '{printf("%04d\n",$1)}'`
		 mv $1/$line  $1/$newpatch
	 done
else
	echo "exit"
	exit
fi

