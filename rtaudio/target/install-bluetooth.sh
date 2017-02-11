pacman -S bluez bluez-utils readline

systemctl enable bluetooth.service
gpasswd -a root lp
#gpasswd -a rtaudio lp
#modprobe btusb


KERNEL=="hci[0-9]*"
In order to have the device active after a reboot, a udev rule is needed:
/etc/udev/rules.d/10-local.rules
# Set bluetooth power up
ACTION=="add", KERNEL=="hci[0-9]*", RUN+="/usr/bin/hciconfig %k up"




After a suspend/resume-cycle, the device can be powered on automatically using a custom systemd service:
/etc/systemd/system/bluetooth-auto-power@.service
[Unit]
Description=Bluetooth auto power on
After=bluetooth.service sys-subsystem-bluetooth-devices-%i.device suspend.target

[Service]
Type=oneshot
ExecStart=/usr/bin/hciconfig %i up

[Install]
WantedBy=suspend.target

Enable an instance of the unit using your bluetooth device name, for example bluetooth-auto-power@hci0.service.




/etc/bluetooth/audio.conf
[General]
Enable=Source



#https://wiki.archlinux.org/index.php/bluetooth
