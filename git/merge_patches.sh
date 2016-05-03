#!/bin/bash

if [ -d $1 ]
then
	mkdir merged-patch
else
	echo "error: $1 isn't directory"
fi


ls $1 | sort | while read line 
do
	git am $1/$line
	if [ $? -eq 0 ]
	then
		echo merge $line
		mv $1/$line merged-patch
	else
		~/github/python-me/module/git/gitMegPatch.py $1/$line
		echo merge $line failed
		exit
	fi
done
