#!/bin/bash
#
set -e

ISD=$1
echo "Installing from $ISD..."
cd $ISD

# unlock in any case
rm -f /var/lib/pacman/db.lck
pacman -Sy

echo "pacman updated"

[[ -f /usr/bin/strings ]] || pacman -S binutils  --noconfirm
[[ -f /usr/bin/hostapd ]] || pacman -S hostapd  --noconfirm
[[ -f /usr/bin/dnsmasq ]] || pacman -S dnsmasq  --noconfirm
[[ -f /usr/bin/wpa_supplicant ]] || pacman -S wpa_supplicant  --noconfirm


#analysis
[[ -f /usr/bin/htop ]] || pacman -S htop --noconfirm


# enable SSH root access
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
#cat /etc/ssh/sshd_config | grep PermitRootLogin


cp rtaudio-config.service /usr/lib/systemd/system/
systemctl enable rtaudio-config.service 2>/dev/null

cp rtaudio-wifi.service /usr/lib/systemd/system/
systemctl enable rtaudio-wifi.service 2>/dev/null
systemctl mask create_ap.service  2>/dev/null


# create a symlink to temporary wifi profile file (/tmp/rtaudio-wifi will be created on boot)
echo "#tmp" > /tmp/rtaudio-wifi
rm -f /etc/netctl/rtaudio-wifi
ln -s /tmp/rtaudio-wifi /etc/netctl/rtaudio-wifi
rm /tmp/rtaudio-wifi

# create a hook to fallback to hotspot
cp -a ./wifi/netctl-hook /etc/netctl/hooks/


#rt opts
mkdir -p /etc/sysctl.d/ /etc/security/limits.d/
cp ./rt/sysctl-rtaudio.conf /etc/sysctl.d/
cp ./rt/99-rtaudio.conf /etc/security/limits.d/
usermod -G audio -a 'root'



#install create ap
[[ -f /usr/bin/create_ap ]] || pacman -U packages/create_ap* --noconfirm
systemctl mask create_ap.service # we have our own service



#echo "warning: skipping custom packages!"
#exit 0

arch=`uname -m`
arch=${arch:0:5}


#install jck2 (custom)
jack_pkg=`find packages/ -name "jack2*$arch*"`


echo "JACK2 $jack_pkg..."
[[ -f /usr/bin/jackd ]] || pacman -U $jack_pkg --noconfirm
cp jack2.service /usr/lib/systemd/system/
systemctl enable jack2.service 2>/dev/null





# not required anymore!
#cp rtaudio-first-boot.service /usr/lib/systemd/system/rtaudio-first-boot.service
#systemctl enable rtaudio-first-boot.service 2>/dev/null
#echo "First boot service added, you have to (re)boot the system now"

systemctl disable rtaudio-first-boot.service 2>/dev/null || true


echo "install script on target finished"

