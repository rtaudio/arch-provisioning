#!/bin/bash

if [ ! -f /tmp/rtaudio-wifi ] && [ ! -f /tmp/create_ap.conf ]; then
	echo "no wifi profile nor AP config, exiting"
	exit 0
fi	


ri=1
while [ -z "`iw dev`" ]; do
  if [ $ri -gt 10 ]; then
    if [ -e /sys/class/net/wl* ]; then
      echo "iw was unable to find a wireless device, but there seems to be at least one device at /sys/class/net/wl*."
      echo "The wireless hardware might be legacy not supporting nl80211 (you can try iwconfig). Exiting."
      exit 0
    fi
    echo "rtaudio: no wifi devices found, exiting."
    exit 0
  fi
  echo "rtaudio: no wifi devices found, retrying ($ri)"
  ri=$[$ri+1]
  sleep 1
done

echo "rtaudio: wifi start ..."

# TODO: check if no ESSID
#line=$(head -n 1 filename)
#first try to connect using a netctl profile
if [ ! -f /tmp/rtaudio-wifi ] || ( ! /usr/bin/netctl start rtaudio-wifi && sleep 1 && ! /usr/bin/netctl start rtaudio-wifi )
then
  echo "rtaudio: netctl failed "
  if [[ ! -f /tmp/create_ap.conf ]]; then
    echo "no wifi access point configuration found, exiting"
    exit 0
  fi
  CNF="`cat /tmp/create_ap.conf`"
    if [[ ! -z "$CNF" && -f /usr/bin/create_ap ]]; then
      echo "create_ap $CNF"
      /usr/bin/create_ap $CNF || /usr/bin/create_ap $CNF --no-virt
    fi
fi

#-n -g 10.0.0.1 wlan0 AccessPointSSID





