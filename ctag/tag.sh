#!/bin/bash
module_list=("driver_mtd")
dyna_tags=()
TAG_ARGS='--c++-kinds=+p --fields=+iaS --extra=+q -R -a -I EXPORT_SYMBOL_GPL+ -I EXPORT_SYMBOL+ -I extern+'
#TAG_ARGS="--c++-kinds=+p --fields=+iaS --extra=+q -R -a "

function module_tag() 
{
for dir_name in $module_list
do
	if [ -f ${dir_name}/tagfiles ]
	then
		rm ${dir_name}/tagfiles
	fi

	filelist_name=$dir_name/file.list
	if [ -f $filelist_name ]
	then
		cat $filelist_name | 
		while read line
		do
			echo $LINUX_SRC/${line} >> ${dir_name}/tagfiles
		done
		#cd ${dir_name}; ctags -L tagfiles --c++-kinds=+p --fields=+iaS --extra=+q -R -a
		cd ${dir_name} && ctags -L tagfiles $TAG_ARGS && cd -
	fi
done
}

function driver_tag() 
{
	driver_files="driver_tag_files"
	if [ -f $driver_files ]
	then
		rm $driver_file
	fi
	DRIVER_DIR=$LINUX_SRC/drivers
	#find $LINUX_SRC -path "$LINUX_SRC/drivers/base" -prune -o -path "$LINUX_SRC/include/linux" -prune -o -path "$LINUX_SRC/kernel" -prune -o -path "$LINUX_SRC/mm" -prune -o -path "$LINUX_SRC/arch/arm" -o -print | grep "\.o$"
	#echo "find $LINUX_SRC -path "$LINUX_SRC/drivers/base" -prune -o -path "$LINUX_SRC/include/linux" -prune -o -path "$LINUX_SRC/kernel" -prune -o -path "$LINUX_SRC/mm" -prune -o -path "$LINUX_SRC/arch/arm" -prune -o -print | grep "\.o$""
	find $DRIVER_DIR -path "$DRIVER_DIR/base" -prune -o -print | grep "\.o$" |
	while read line 
	do

		line_head=$line
		line_head=${line//.o/.h}
		line_src=${line//.o/.c}
		if [ -f $line_src ]
		then
			echo $line_src
			echo $line_src >> $driver_files
			if [ -f $line_head ]
			then
				echo $line_head
				echo $line_head >> $driver_files
			fi
		fi

	done
	ctags -f linux_base-tags -L $driver_files $TAG_ARGS 
}

if [ $# == 0 ]
then
	echo "err: not linux src path"
	exit;
fi

#ctags --c++-kinds=+p --fields=+iaS --extra=+q -R -a  /export/disk1T1/bsp_work/wrlinux/wrlinux7/prj/ti-am335x-rt/bitbake_build/tmp/work-shared/ti-am335x/kernel-source/mm
LINUX_SRC=$1
module_tag
if [ -d $LINUX_SRC ]
then
	if [ -f linux_base-tags ]
	then
		rm linux_base-tags
	fi
	#map <F5> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR><CR> :TlistUpdate<CR>
	ctags -f linux_base-tags $TAG_ARGS $LINUX_SRC/drivers/base/
	ctags -f linux_base-tags $TAG_ARGS $LINUX_SRC/include/linux/
	ctags -f linux_base-tags $TAG_ARGS $LINUX_SRC/kernel
	ctags -f linux_base-tags $TAG_ARGS ${LINUX_SRC}/mm
	ctags -f linux_base-tags $TAG_ARGS ${LINUX_SRC}/arch/arm/common
	ctags -f linux_base-tags $TAG_ARGS ${LINUX_SRC}/arch/arm/kernel
	ctags -f linux_base-tags $TAG_ARGS ${LINUX_SRC}/arch/arm/mm

else
	echo "err: it isn't a direcotry"
fi
driver_tag
