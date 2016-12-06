# What is this?

This is a toolset to create headless embedded systems with a lighweight Arch Linux ARM that boots within seconds and performs real-time tasks.
It's initial focus is on real-time audio processing.
Currently tested with the Raspberry PI 2 it should run on other ARM SoCs (supported by arch linux ARM)[https://archlinuxarm.org/platforms] due to its generality.

# What's in there?
It comes with several scripts for a linux host:
* SD card preparation and flashing of bootloader
* a chroot script to alter the Arch Linux ARM on any x68/x64 linux host
* incremental sync to SD card and via SSH of root filesystem
* Minifier to reduce the compelete OS size to about 200MB (for small ramfs images)

For the ARM system it has:
* easy Wi-Fi adapter management that automatically creates a hotspot if no wireless network is available. The SoC will always be accessible, even without any network infrastructure or cable (only a WI-Fi USB dongle is needed)
* It can boot into a RAM disk so the SD-Card module can be disabled. This increases real-time reliability
* Custom systemd services for initial boot automation
* Configuration service that enables configuration through a FAT-partition from a Windows machine
* Some boot optimization techniques (not all possible). The aim is to get the system to boot within 5 seconds

# Getting started

Clone this repo on a linux host (required packages on host: ```bsdtar sshfs qemu binfmt-support qemu-user-static``` )

* `./rootfs-init` : Choose your board, it will then download the latest Arch Linux ARM image
* `./sdcard-prepare` while downloading, run this to initialize an SD card (SD card will be erased!)
* `./rootfs-sync-to-sdcard` after all previous steps are done, run this to copy the rootfs to the SD card
* `./sdcard-unmount` to unmount the SD card
You can then plug the card into your ARM embedded system and it will boot. It will create a WiFi hotspot you can connect to.

To start over with a fresh rootfs, delete, rename or move the `work/` dir.



