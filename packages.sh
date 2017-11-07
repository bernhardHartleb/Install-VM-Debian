#!/bin/bash
# Adrian Remonda 2013
# Bernhard Hartleb 2016

sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade

echo "### Installing basic tools"
# Allows us to add debian repositories
sudo apt-get install -y software-properties-common curl > /dev/null

echo "### Installing ssh server"
sudo apt-get install -y openssh-server > /dev/null

echo "### Installing versioning tools"
sudo apt-get install -y git gitk git-gui mercurial subversion > /dev/null

echo "### Installing compression tools"
sudo apt-get install -y zip unzip unrar-free p7zip xarchiver > /dev/null

echo "### Installing vim"
sudo apt-get install -y vim vim-gnome exuberant-ctags > /dev/null

echo "### Installing compiling tools"
sudo apt-get install -y build-essential gcc gdb autoconf libtool ncurses-dev xutils-dev colorgcc > /dev/null

echo "### Installing kernel tools"
sudo apt-get install -y linux-tools bison flex texinfo gnuplot gnuplot-x11 > /dev/null

echo "### Installing networking tools"
sudo apt-get install -y wireshark > /dev/null

echo "### Installing misc tools"
sudo apt-get install -y gparted minicom gtkterm > /dev/null

echo "### Installing Python"
sudo apt-get install -y python python3 python-serial python-setuptools python-gpgme > /dev/null
sudo apt-get install -y python-matplotlib > /dev/null

echo "### Installing Go"
sudo apt-get install -y golang > /dev/null

#echo "### Installing x86 toolchain. Necesesary for Xilinx tools and bb kernel"
#sudo dpkg --add-architecture i386
#sudo apt-get -y update
#sudo apt-get install -y libc6:i386 libncurses5:i386 libstdc++6:i386 zlib1g:i386

echo "### Installing embedded linux tools"
sudo apt-get install -y device-tree-compiler debootstrap lzma lzop u-boot-tools

#echo "### Installing Qt5 development libraries"
#sudo apt-get install qt5-default

# Personal preference
echo "### Installing optional console tools"
sudo apt-get install -y tree meld xclip > /dev/null
#sudo apt-get install -y mate-extras guake
