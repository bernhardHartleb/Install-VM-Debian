## Install Debian in Virtual Box and connect to Zynq development board (ESP lecture, FH Joanneum)

 - Install and open Oracle VM VirtualBox version 5.1.XX from https://www.virtualbox.org/
 - Download Debian from: https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-9.2.1-amd64-netinst.iso
 - Click New in VirtualBox
 - Name your new VM “Debian 9.2” choose Type “Linux” and Version “Debian 64Bit”. Click Next.
 - Choose a memory size (RAM). Recommended half of thes system memory. At least 1024MB. Click Next.
 - Hard Disk: Create a virtual Hard disk now. Click Create.
 - Hard disk file Type: VDI. Click Next.
 - Storage on physical hard disk: Dynamically allocated. Click Next.
 - File location and size: Choose a path, on which the virtual hard disk gets placed. Choose a maximum size. At least 12GB. Click Create.
 - In your VirtualBox Manager, you now have a VM listed. On the right side, you can see the properties of your VM.
 - Go to Change and add a shared folder to the VM configuration. Select "Automatically mount" and click OK.
 - Click the start Button to boot the VM.
 - A window “Select start-up disk” appears. Choose the Debian ISO downloaded before. Click Start.
 - Linux is booting from the install media. Press Enter to start the installation.
 - Choose your language (English) and press Enter
 - Select your location and press Enter
 - Configure the keyboard: Select your keyboard standard.
 - Network configuration is automatically detected.
 - Hostname: Your FH login. Is used for reference only.
 - Domain Name: leave empty. Press Continue.
 - Set up users and passwords: Root password: root
 - Full Name: [your name], User name for your account: [your choice], password: [your pw]
 - Partition disks: Guided – use entire disk.
 - Select disk to partition: Just one should be available. Choose it.
 - Partition disks: All files in one partition
 - Finish partitioning and write changes to disk
 - Partition disks and write changes: Yes
 - Wait until base system is installed.
 - Scan another CD / DVD: No
 - Choose a mirror of the Debian archive: Country in which you are now. If Austria, choose ftp.tu-graz.ac.at
 - Proxy: leave blank. Press Enter.
 - Configuring popularity-contest: make your own decision.
 - Software selection: Select MATE by pressing space bar. Unselect “Debian desktop environment” by pressing space bar. Press Enter.
 - Wait until full system is installed.
 - Install the GRUB boot loader on a hard disk: Yes, on /dev/sda (ata-VBOX...)
 - Finish the installation: Continue.
 - If Debian installation appears again: Press Devices -> Optical Drives -> Remove install disk. Reboot the VM.
 - Debian Linux is starting! Your will the the bootloader followed by a login prompt.
 - Login with the username selected during installation.

Now we setup the debian system.
Go to: System -> Preferences -> Keyboard -> Layouts and check that only your Keyboard layout is in the list.
Go to: System -> Preferences -> Screensaver and disable it (both checkboxes).
Find Application -> System Tools -> MATE Terminal and drag & drop the icon to the desktop.

Open the terminal and run the following commands:
This will add your user to the sudo and dialout groups, allowing us to work without beeing root in the future.
```sh
$ su -
# apt-get install sudo mate
# adduser <username> sudo
# adduser <username> dialout
# reboot
```

The VirtualBox guest additions are drivers required for seamless graphics, mouse input, shared clipboard and shared folders.
The following build tools are needed to install guest additions:
```sh
$ sudo apt-get install gcc gdb build-essential git linux-headers-$(uname -r)
```

Confirm and install the selected packages.
Now insert the guest additions CD:
Devices -> Insert Guest Additions CD image...
If we have to start the setup manually:
```sh
$ su
# cd /media/cdrom
# sh ./VBoxLinuxAdditions.run 
# adduser <username> vboxsf
# reboot
```
You should now see your shared folder on the desktop.
If there are no issues, shutdown the VM create a restore point of the current state.

## Development tools

Find a way to copy the packages.sh file into the virtual machine and run it from the console.
This will install some basic packages required for future labs:
```sh
$ ./packages.sh
```

Install a cross compiler for "armhf" (ARM hard floating point) to compile Linux applications for the Zybo board.
```sh
$ cd /etc/apt/sources.list.d/
$ su
# cat > crosstools.list
# deb http://emdebian.org/tools/debian/ jessie main
“press ctrl+D to save file”
# exit
$ curl http://emdebian.org/tools/debian/emdebian-toolchain-archive.key | sudo apt-key add -

$ sudo dpkg --add-architecture armhf
$ sudo apt-get update
$ sudo apt-get install crossbuild-essential-armhf
```

Install a x86 toolchain (32bit) necesesary for Xilinx tools and BSP kernel
```sh
$ sudo dpkg --add-architecture i386
$ sudo apt-get update
$ sudo apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386 zlib1g:i386 
$ sudo apt-get install libssl-dev
```

## (Optional) VM optimization

Optimize your VM to save time in the future:
 - Enable the shared clipboard between Host and Guest.
 - Assign a 2nd CPU to the VM if available.
 - Assign more than 1GB of RAM.
 - Activate 3D acceleration and increase graphics memory to 64MB.
 - Find the best display resolution and scaling mode for your work.
 - Discover the MATE desktop.

## Connect to the target via serial console

The most basic access to any embedded system is often the serial console. Since serial ports went mostly extinct, USB is used to transport the serial data instead.
These instructions work assuming we boot the default Linux installation from QSPI flash.

- Change the boot-mode jumpers to boot from QSPI.
- Connect the Zybo board via the mircoUSB connector to your host PC. This connection powers the board and acts as console at the same time.
- Wait until your Windows host finishes installing drivers.
- Click on Devices -> USB -> Silicon Labs CP2014 USB to UART Bridge. This forwards the USB device to the VM.
- Open gtkterm.
- Click Configuration -> Port: Choose /dev/ttyUSB0 at 115200 Baud.
- Click OK. Press Enter a few times in the black console.
- The Zynq command prompt appears.

You are now working with Linux on the Zybo board! Do not modify files in the default installation. A custom image on the SDCard should be used for that.

## Connect to the target via network

In this example a standalone configuration with fixed IP addresses is created, connecting the board directly to the host computer. A simple alternative is to rely on the DHCP server of your network and run "udhcpc" on the development board.
First of all, the network card setting on Windows has to be changed as follows:

*	IP: 192.168.1.150 
*	Subnet mask:255.255.255.0

Also the network of the virtual machine have to get adjust. To make an internet connection on the Zybo board possible, a second network has to get included in the virtual box setting, and attached to Bridge adapter.
This can be done in the following way:

* Network -> adapter 2 -> bridge connection -> Name of your network card, which is connected to the board. 

To connect the adapter2 to the board, the network has to get configured as follow:

```sh
$ sudo echo -e "auto eth1\niface eth1 inet static\naddress 192.168.1.200\nnetmask 255.255.255.0\n" >> /etc/network/interfaces
```

With this configuration, an internet connection on the Zybo board can get established by executing the following commands as root.
(This has to be done after every reboot of the virtual machine.)
```sh
$ su
# echo 1 > /proc/sys/net/ipv4/ip_forward
# iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
# iptables -A FORWARD -i eth0 -o eth1 -m state --state RELATED,ESTABLISHED -j ACCEPT
# iptables -A FORWARD -i eth1 -j ACCEPT
```

To connect to the board, use the following command:
```sh
$ ssh root@$192.168.1.120
```

To view the file system on the board the following command can be used:
```sh
$ caja "sftb://$192.168.1.120/root"
```
