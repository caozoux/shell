#!/bin/bash
module_list=("driver_mtd")
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
	#map <F5> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR><CR> :TlistUpdate<CR>
	ctags -f linux_base-tags $TAG_ARGS $LINUX_SRC/drivers/base/
	ctags -f linux_base-tags $TAG_ARGS $LINUX_SRC/include/linux/
	ctags -f linux_base-tags $TAG_ARGS $LINUX_SRC/kernel
	ctags -f linux_base-tags $TAG_ARGS ${LINUX_SRC}/mm

else
	echo "err: it isn't a direcotry"
fi
