#!/bin/bash

set -e

sleep 1

echo "" > /dev/tty0
echo "" > /dev/tty0
echo "" > /dev/tty0
echo "Installing RT-Audio (first boot) ..." > /dev/tty0
echo "start in 5 seconds..."  > /dev/tty0
sleep 5

cd /home/rtaudio


echo "Installation successful! Cleaning up..." > /dev/tty0
systemctl disable rtaudio-first-boot.service
echo "Done!"

exit 0
