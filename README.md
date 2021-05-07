## Install Debian in VirtualBox and connect to Zybo development board

 - Check and enable Virtualization instructions on your PC! Check with Task Manager and enable in BIOS if disabled.
 - Install and open latest Oracle VirtualBox 6.1.X VM Software from https://www.virtualbox.org/
 - Download Debian "amd64 iso-cd" image from: https://cdimage.debian.org/debian-cd/10.9.0/amd64/iso-cd/debian-10.9.0-amd64-netinst.iso
 - Click New in VirtualBox
 - Name your new VM “Debian 10.9” choose Type “Linux” and Version “Debian 64Bit”.
 - Choose a memory size (RAM). Recommended half of thes system memory. At least 4096MB.
 - Hard Disk: Create a virtual Hard disk.
 - Click Create.
 - File location and size: Choose a path at which the virtual hard disk is stored. 
 - Hard disk file Type: VDI.
 - Storage on physical hard disk: Dynamically allocated.
 - Choose a maximum size. Minimum 8GB! Make sure you have at least 2GB free disk space initially.
 - Click Create.
 - In your VirtualBox Manager, you now have a VM listed. On the right side, you can see the properties of your VM.
 - Click Change. Add a new shared folder to the VM configuration folder name "shared". 
 - Create a new shared directory in your lecture folder and select it as path.
 - Select "Automatically mount" and click OK.
 - Click the start Button to boot the VM.
 - A window “Select start-up disk” appears. Choose the Debian ISO downloaded before. Click Start.
 - Linux is booting from the install media. Press Enter to start the Graphical installation.
 - Choose your language (English) and press Enter.
 - Select your location and press Enter.
 - Keep the default locale en_US.UTF-8
 - Select your keyboard standard.
 - Network configuration is automatically detected.
 - Hostname: Your FH login. Is used for reference only.
 - Domain Name: leave empty. Press Continue.
 - Password for root: root
 - Set up a simple username and password:
 - Full Name: [your name], User name for your account: [your choice], password: [your pw]
 - Partition disks: Guided – use entire disk.
 - Select disk to partition: Just one should be available. Choose it.
 - Partition disks: All files in one partition
 - Finish partitioning and write changes to disk
 - Partition disks and write changes: Yes
 - Wait until base system is installed.
 - Scan another CD / DVD: No
 - Choose a mirror of the Debian archive: Country in which you are now.
 - Proxy: leave blank. Press Enter.
 - Configuring popularity-contest: make your own decision.
 - Software selection: Select MATE by pressing space bar. Unselect “Debian desktop environment”!
 - Wait until full system is installed.
 - Install the GRUB boot loader on a hard disk: Yes, on /dev/sda (ata-VBOX...)
 - Finish the installation: Continue.
 - If the Debian installer starts again: Press Devices -> Optical Drives -> Remove install disk. Reboot the VM.
 - Debian Linux is starting! You will see the bootloader followed by a login prompt.
 - Login with your username selected during installation.

Now we can configure the Debian and our desktop environment.
Go to: System -> Preferences -> Keyboard -> Layouts and check that only your Keyboard layout is in the list.
Go to: System -> Preferences -> Screensaver and disable it (both checkboxes).
Find Application -> System Tools -> MATE Terminal and drag & drop the icon to the desktop.

Open the terminal and run the following commands:
This will add your user to the sudo and dialout groups, allowing us to work without beeing root in the future.
```sh
$ su -
# apt-get install sudo mate
# adduser [username] sudo
# adduser [username] dialout
# reboot
```

The VirtualBox guest additions are drivers required for seamless graphics, mouse input, shared clipboard and shared folders.
The following build tools are needed to install guest additions:
```sh
$ sudo apt-get install gcc gdb build-essential dkms linux-headers-$(uname -r)
```

Confirm and install the selected packages.
Now insert the guest additions CD:
Devices -> Insert Guest Additions CD image...
Start the setup by hand:
```sh
$ su -
# cd /media/cdrom
# sh ./VBoxLinuxAdditions.run 
# adduser [username] vboxsf
# reboot
```
You should now see your shared folder on the desktop.
If there are no issues, shutdown the VM create a restore point of the current state.

## Development tools

Find a way to copy the packages.sh file from this Github repository into the virtual machine and execute it from the console. Make sure to get the file and not the HTTP webpage! This will install some basic packages required for future labs:
```sh
$ chmod +x packages.sh
$ ./packages.sh
```

Install a cross compiler for "armhf" (ARM hard floating point) to compile Linux applications for the Zybo board (Cortex-A9).
```sh
$ sudo dpkg --add-architecture armhf
$ sudo apt-get update
$ sudo apt-get install crossbuild-essential-armhf
```

## VM optimization

Optimize your VM to save time in the future:
 - Enable the shared clipboard between Host and Guest.
 - Assign a 2nd CPU to the VM.
 - Assign more than 2GB of RAM.
 - Activate 3D acceleration and increase graphics memory to 64MB.
 - Find the best display resolution and scaling mode for your work.
 - Discover the simple MATE desktop.

## Connect to the target via serial console

The most basic access to any embedded system is often the serial console. Since serial ports went mostly extinct, USB is used to transport the serial data instead.
These instructions work assuming we boot the default Linux installation from QSPI flash.

- Change the boot-mode jumpers to boot from QSPI.
- Connect the Zybo board via the mircoUSB connector to your host PC. This connection powers the board and acts as console at the same time.
- Wait until your Windows host finishes installing drivers.
- Click on Devices -> USB -> Digilent Adept USB Device. This forwards the USB serial convert to the VM.
- USB forwarding can be made automatic by adding the device in the USB configuration dialog.
- Open gtkterm.
- Click Configuration -> Choose /dev/ttyUSB1 at 115200 Baud.
- Click OK. Press Enter a few times in the black console.
- The Zybo command prompt appears.
- If this works then select in Configuration -> Save configuration -> default

You are now working with Linux on the Zybo board! Do not modify files in the default installation. A custom image on the SDCard should be used for that.

## Connect to the target via network

In this example a standalone configuration with fixed IP addresses is created, connecting the board directly to the host computer. A simple alternative is to rely on the DHCP server of your network and run "udhcpc" on the development board.
First of all, the network card setting on Windows has to be changed as follows:

*	IP: 192.168.1.150 
*	Subnet mask:255.255.255.0

Also the network of the virtual machine has to be adjusted. To make an internet connection on the Zybo board possible, a second network has to get included in the virtual box setting, and attached to Bridge adapter.
This can be done in the following way:

* Network -> Adapter 2 -> Bridge connection -> Name of your network card, which is connected to the board.

To connect the Adapter2 to the board, the network has to be configured as follows:

```sh
$ sudo -i
$ echo -e "auto enp0s8\niface enp0s8 inet static\naddress 192.168.1.200\nnetmask 255.255.255.0\n" > /etc/network/interfaces.d/bridge
```

After a restarted of the VM the Zybo board should now be available in your LAN.
To connect to the board, use the following command:
```sh
$ ssh root@192.168.1.103
```

To transfer files manually:
```sh
$ scp hello-arm root@192.168.1.103:/root/
```

To view the file system on the board the following command can be used:
```sh
$ caja "sftp://root@192.168.1.103/root"
```

As an additional option, an internet connection on the Zybo board can get established by executing the following commands as root.
(This has to be done after every reboot of the virtual machine.)
```sh
$ su
# echo 1 > /proc/sys/net/ipv4/ip_forward
# iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE
# iptables -A FORWARD -i enp0s3 -o enp0s3 -m state --state RELATED,ESTABLISHED -j ACCEPT
# iptables -A FORWARD -i enp0s8 -j ACCEPT
```
