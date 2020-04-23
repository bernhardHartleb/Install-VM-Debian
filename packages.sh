#!/bin/bash
# Bernhard Hartleb 2020

sudo apt-get -y update
sudo apt-get -y upgrade

echo "### Installing basic tools"
# Allows us to add debian repositories
sudo apt-get install -y software-properties-common curl > /dev/null

echo "### Installing ssh server"
sudo apt-get install -y openssh-server > /dev/null

echo "### Installing version control"
sudo apt-get install -y git gitk git-gui > /dev/null

echo "### Installing compression tools"
sudo apt-get install -y zip unzip unrar-free lzma lzop p7zip xarchiver > /dev/null

echo "### Installing vim"
sudo apt-get install -y vim exuberant-ctags > /dev/null

echo "### Installing build tools"
sudo apt-get install -y build-essential gcc gdb autoconf libtool ncurses-dev xutils-dev > /dev/null

echo "### Installing kernel tools"
sudo apt-get install -y dkms bison flex texinfo gnuplot gnuplot-x11 > /dev/null

echo "### Installing networking tools"
sudo apt-get install -y net-tools wireshark-gtk > /dev/null
sudo adduser $USER wireshark

echo "### Installing terminals"
sudo apt-get install -y minicom gtkterm > /dev/null
sudo adduser $USER dialout

echo "### Installing Python3"
sudo apt-get install -y python python3 python-serial python-setuptools > /dev/null
sudo apt-get install -y python-numpy python-matplotlib > /dev/null

echo "### Installing Go"
sudo apt-get install -y golang > /dev/null

echo "### Installing benchmark tools"
sudo apt-get install -y linux-perf htop strace stress > /dev/null

echo "### Installing embedded linux tools"
sudo apt-get install -y device-tree-compiler debootstrap gparted u-boot-tools > /dev/null

#echo "### Installing x86 toolchain"
# Necesesary to run Xilinx tools
#sudo dpkg --add-architecture i386
#sudo apt-get -y update
#sudo apt-get install -y libc6:i386 libncurses5:i386 libstdc++6:i386 zlib1g:i386
#sudo apt-get install -y libssl-dev

#echo "### Installing Qt5 development libraries"
#sudo apt-get install qt5-default

# Personal preference
echo "### Installing optional console tools"
sudo apt-get install -y tree meld xclip > /dev/null
#sudo apt-get install -y mate-extras guake
