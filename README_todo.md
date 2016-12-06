
# Everything todo below:
This repo includes:
* Generic Toolchain for partition of SD-Card and incremental arch linux deployment
* A QEMU-emulated chroot script to chroot into the embedded root file system on any non-ARM (x68/x64) linux  host system (e.g. to install additional packages through pacman)













You will never need to do any manual configuration/SSH connection to the embedded system. Comfortably prepare/maintain the OS on your linux machine or virtual machine. Changes can be deployed quickly through an icremental sync with the SD-Card or over SSH.

# TODO
* boot optimim: disable raid6 calibration

# Getting started

* Get root permissions ```su root```
* Run ```./fix-permissions.sh``` to setup attributes and create empty directories in ```./root``` (requires an automatic download of the latest arch linux release)
* Create SD card partition with ```./init-sd-card.sh```
* 

The above in a single command where ```sdX``` is the SD-card:
```DEV=sdX && ./fix-permissions.sh && ./umount-sd-card.sh $DEV && ./init-sd-card.sh $DEV && ./copy-to-sd-card.sh && ./umount-sd-card.sh $DEV```

# Additionally installed Packages
* irman
* dnsmasq (DHCP server)
* hostapd (WiFi hotspot)
* jack2

# system.d services
create_ap.service
hostapd.service
streamer.service



# Need Remove
xinit, anything x

# Scripts
/root/remount_root_rw.sh
/root/arm-dev/start-streamer.sh

# Dev files files (should be modulized in external repos TODO)
/root/arm-dev/udp2jack




# rpi-low-latency-audio

* Arch linux for RPI2
* root file system located in ```root/```
* 
You should clone as root, not with sudo:
```su root
git clone https://github.com/rtaudio/rpi-low-latency-audio.git
```

# Additionally installed Packages
* irman
* dnsmasq (DHCP server)
* hostapd (WiFi hotspot)
* jack2

# system.d services
create_ap.service
hostapd.service
streamer.service



# Need Remove
xinit, anything x

# Scripts
/root/remount_root_rw.sh
/root/arm-dev/start-streamer.sh

# Dev files files (should be modulized in external repos TODO)
/root/arm-dev/udp2jack
