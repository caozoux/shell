#!/bin/bash

#number="1";cat onelinelog | cut -d ' ' -f 1 | sed '1!G;h;$!d' | while read line; do echo $line; number=`expr $number + 1`; git format-patch --start-number $number -1 $line -o cach; done
number="1"

if [ -f $1 ]
then
	echo ""
else
	echo "Err: $1 not exist"
	exit
fi

dirname=""
dirname=`date "+%H_%M_%S"`
mkdir $dirname
git log --pretty=oneline $1 > onelinelog
cat onelinelog | cut -d ' ' -f 1 | sed '1!G;h;$!d' | 
while read line
do 
	echo $line;
	number=`expr $number + 1`;
	git format-patch --start-number $number -1 $line -o  $dirname
done
