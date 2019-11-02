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

git clone --branch vimwiki https://github.com/caozoux/vim.git ~/github/vim
ln -s ~/github/vim/vimrc ~/.vimrc
ln -s ~/github/vim/.vim ~/
mkdir ~/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone https://github.com/vim/vim.git ~/github/vim_src

build_vim8
