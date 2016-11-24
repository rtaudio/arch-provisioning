#analyze:
# ssh root@192.168.2.122 "systemd-analyze plot" > systemd-analyze-plot.svg


# add quiet kernel parameter
[[ -z `cat /boot/cmdline.txt | grep quiet` ]] && sed -i 's/rootwait/rootwait quiet/g' /boot/cmdline.txt

# disable in kernel? sys-devices-virtual-block-ram0.device
