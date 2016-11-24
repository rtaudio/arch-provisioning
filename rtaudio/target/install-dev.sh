#!/bin/bash
#
set -e

ISD=$1
echo "Installing dev packages from $ISD..."
cd $ISD

# unlock in any case
rm -f /var/lib/pacman/db.lck
pacman -Sy


[[ -f /usr/bin/cmake ]] || pacman -S cmake  --noconfirm
[[ -f /usr/bin/make ]] || pacman -S make  --noconfirm
[[ -f /usr/bin/gcc ]] || pacman -S gcc  --noconfirm



echo "install-dev script on target finished"

