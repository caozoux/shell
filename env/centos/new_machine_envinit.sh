#!/bin/bash

function build_rpms()
{
	sudo yum install -y ncurses-devel bash-completion ctags cscope
}

function build_vim8()
{
	cd ~/github/vim_src;
	git checkout cd142e3369db8888163a511dbe9907bcd138829c
	git am ~/github/shell/env/centos/0001-update.patch 
	./configure -with-features=huge -enable-rubyinterp -enable-pythoninterp  -enable-multibyte -enable-cscope --with-python-config-dir=/usr/lib64/python2.7/config --enable-cscope --prefix=/usr/local
	make VIMRUNTIMEDIR=/usr/local/share/vim/vim8 -j16
	sudo make install
}


function vim_install() {
	git clone --branch vimwiki https://github.com/caozoux/vim.git ~/github/vim
	ln -s ~/github/vim/vimrc ~/.vimrc
	ln -s ~/github/vim/.vim ~/
	mkdir ~/.vim/bundle
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	git clone https://github.com/vim/vim.git ~/github/vim_src

	build_vim8
}

function gcc10_install() {
	sudo yum install centos-release-scl
	sudo yum install devtoolset-10
	scl enable devtoolset-10 bash
	#function_body
}

function kernelbuild_depsrpm_install() {
	yum install  -y net-tools.x86_64 nfs-utils protmap vim git rpm-build redhat-rpm-config asciidoc hmaccalc perl-ExtUtils-Embed pesign xmlto audit-libs-devel binutils-devel elfutils-devel elfutils-libelf-devel ncurses-devel newt-devel numactl-devel pciutils-devel python-devel zlib-devel bison  wget java-devel bt 

	#sudo yum install nfs-utils
	#systemctl enable nfs-server.service
	#systemctl start nfs-server.service

	#function_body
}
__ScriptVersion="1.0"

#===  FUNCTION  ================================================================
#         NAME:  usage
#  DESCRIPTION:  Display usage information.
#===============================================================================
function usage ()
{
	echo "Usage :  $0 [options] [--]

    Options:
    -h|help       Display this message
    -i|vim        install vim
    -k|kernelrpms install kernel buiild dep rpms
    -c|gcc        install gcc9 or gcc 10
    -v|version    Display script version"

}    # ----------  end of function usage  ----------

#-----------------------------------------------------------------------
#  Handle command line arguments
#-----------------------------------------------------------------------

while getopts ":hvickc" opt
do
  case $opt in

	h|help     )  usage; exit 0   ;;

	v|version  )  echo "$0 -- Version $__ScriptVersion"; exit 0   ;;
	k|kernelrpms )
		kernelbuild_depsrpm_install
		exit 0   ;;
	c|gcc      )
		gcc10_install
		exit 0   ;;

	* )  echo -e "\n  Option does not exist : $OPTARG\n"
		  usage; exit 1   ;;

  esac    # --- end of case ---
done
shift $(($OPTIND-1))
