
## Install Debian in VirtualBox and connect to Zybo development board

 - Check Virtualization instructions by opening the CPU performance view of Windows Task Manager.
 - Enable Virtualization support in UEFI if disabled.
 - Install and open the latest Oracle VirtualBox 7.2.X VM Software from https://www.virtualbox.org/
 - Download Debian "amd64 iso-cd" image from:
   https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-13.1.0-amd64-netinst.iso
 - Create new Machine in VirtualBox.
 - Select the ISO Image file you downloaded.
 - Disable the checkbox for Unattended Installation. We are making extra choices.
 - Name your new VM “Debian 13.1” choose Type “Linux” and OS “Debian (64-Bit)”.
 - Under Virtual Hardware, choose a memory size (RAM). At least 4096MB is recommended.
 - Increase the number of processors to half the available ones.
 - Enable Use UEFI.
 - Under Hard Disk: Create a virtual Hard disk with following settings:
 - File location: Choose a local path with enough space at which the virtual hard disk is stored.
 - Choose a maximum disk size of at least 12GB! Make sure you have 4GB of free disk space initially.
 - Hard disk file Type: VDI.
 - Click Finish.
 - In your VirtualBox Manager, you now have a VM listed. On the right side you can see the properties.
 - Click Setting and go to Shared Folders.
 - With the plus icon, add a new shared folder to the VM configuration.
 - Create a new shared directory in your lecture folder and select it as Path.
 - Select "Auto-mount" and click OK. Mount point is left empty.
 - Under Display, increase the Video Memory to 32MB.
 - The basic setup of your VM is complete, we come back to it later.
 - Click the start Button to boot the VM.
 - Linux is booting from the install Debian CD iso file.
 - If the VM screen is very small, you can scale in the menu under View -> Virtual Screen.
 - Press Enter to start the Graphical installation.
 - Choose your language (English) and press Enter.
 - Select your location (other -> Europe -> Austria) and press Enter.
 - Keep the default locale en_US.UTF-8
 - Select your keyboard configuration: German for QWERTZ keyboards.
 - Network configuration is automatically detected.
 - Hostname: Your FH username (not email). This is used for reference only.
 - Domain Name: leave empty. Press Continue.
 - Password for root: root
 - Set up a simple username and password, you will type it often:
 - Full Name: [your name], User name for your account: [your alias], password: [your pw]
 - Partition disks: Guided – use entire disk.
 - Select disk to partition: Just one should be available. Choose it.
 - Partition disks: All files in one partition
 - You are present with a list of partitions. Select Finish partitioning and write changes to disk.
 - Partition disks and write changes: Yes
 - Wait until the base system is installed.
 - Scan extra installation media: No
 - Choose a mirror of the Debian archive: Austria
 - Choose the default mirror: deb.debian.org
 - Proxy: leave blank. Press Enter.
 - Wait until the package manager is done updating.
 - Configuring popularity-contest: No
 - Desktop environment selection: Unselect "GNOME". Select "MATE" instead.
 - Wait until the full system is installed.
 - If asked, install the GRUB boot loader on a hard disk: Yes, on /dev/sda (ata-VBOX...)
 - Finish the installation: Continue.
 - If the Debian installer starts again: Press Devices -> Optical Drives -> Remove install disk. Reboot the VM.
 - Debian Linux is starting! You will see the bootloader followed by a login prompt.
 - Login with your username selected during installation.

Now we can configure the Debian and our desktop environment.  
Go to: System -> Preferences -> Hardware -> Keyboard -> Layouts and check that your Keyboard layout is in the list.  
Go to: System -> Preferences -> Look and Feel -> Screensaver and disable it (both checkboxes).  
Find Application -> System Tools -> MATE Terminal and drag & drop the icon to the desktop.

Open the terminal from Applications -> Systems and Tools -> META Terminal and run the following commands.
Do not type the leading characters. $ indicates a normal user shell, while # shows a root shell.
Fill in the placeholder with your own username.
This will add your user to the sudo and dialout groups, allowing us to work without beeing root in the future.
```sh
$ su -
# adduser [username] sudo
# adduser [username] dialout
# exit
```

The VirtualBox guest additions are drivers required for seamless graphics, mouse input, shared clipboard and shared folders.
The following build tools are needed to install guest additions:
```sh
$ su -
# apt-get install gcc gdb build-essential dkms
# exit
```

Confirm and install the specified packages.  
Afterwards insert the guest additions CD:  
VirtualBox -> Devices -> Insert Guest Additions CD...
Then open the CD in your VM:
MATE -> Places -> VBox_GAs_...  
Start the setup by hand in a new terminal:
```sh
$ su -
# cd /media/cdrom0
# ls -1
# sh ./VBoxLinuxAdditions.run 
# adduser [username] vboxsf
# poweroff
```
After starting again and login you should see your shared folder on the desktop.
The size of the Linux desktop now adjusts when resizing the VM window.

## Development tools

Find a way to copy the packages.sh file from this Github repository into the VM and execute it from the console. Make sure to get the plain file and not the HTML webpage!  
This will install some basic packages required for future labs:
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

Optimize your VM to work effective in the future.
Ensure the following things are set:
 - Assign 2 or more CPUs to the VM.
 - Assign more than 4GB of RAM.
 - Increase graphics memory to 32MB.
 - Enable the shared clipboard between Host and Guest.
 - Find the best display resolution and scaling mode for your screen.
 - Add shortcuts to often used applications to the desktop.

When everything works properly, consider shutting down the VM to create a restore point of the current state.

## Connect to the target via serial console

The most basic access to any embedded system is often the serial console. Since serial ports went mostly extinct, USB is used to transport the serial data instead.

- Change the boot-mode jumpers to boot from SD-card and make sure it is inserted.
- Connect the Zybo board via the mircoUSB connector to your host PC. This connection powers the board and acts as console at the same time.
- Wait until your Windows host finishes installing drivers.
- Click on Devices -> USB -> Digilent Adept USB Device. This forwards the USB serial convert to the VM.
- USB forwarding can be made automatic by adding the device in the USB configuration dialog.
- Open gtkterm, via Applications -> Accessories -> Serial port terminal
- Click Configuration -> Choose /dev/ttyUSB1 at 115200 Baud.
- Click OK. Press Enter a few times in the black console.
- The Zybo command prompt appears.
- If this works then select in Configuration -> Save configuration -> default

You are now working with Linux on the Zybo board!  
A custom image on the SD-card should be used for all exercises.

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
$ ssh debian@192.168.1.103
```

To transfer files manually:
```sh
$ scp hello-arm debian@192.168.1.103:
```

To view the file system on the board the following command can be used:
```sh
$ caja "sftp://debian@192.168.1.103/home/debian/"
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
