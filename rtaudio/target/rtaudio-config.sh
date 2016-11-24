#!/bin/bash

# this script applies configuration from the boot partition

CNF_DIR="/boot/rtaudio-config"

[ -f $CNF_DIR/wifi-access-point.conf ] && cp $CNF_DIR/wifi-access-point.conf /tmp/create_ap.conf
[ -f $CNF_DIR/wifi-profile.conf ] && cp $CNF_DIR/wifi-profile.conf /tmp/rtaudio-wifi
[ -f $CNF_DIR/jackd.env ] && cp $CNF_DIR/jackd.env /tmp/jackd.env
if [ -f $CNF_DIR/hostname ]; then
	HOSTNAME=`head -n1 $CNF_DIR/hostname`
	HOSTNAME=${HOSTNAME/.local/} # remove .local suffix
	if [ "`hostname`" != "$HOSTNAME" ]; then
		echo "Updating hostname to $HOSTNAME"
		hostnamectl set-hostname $HOSTNAME
	fi
fi

