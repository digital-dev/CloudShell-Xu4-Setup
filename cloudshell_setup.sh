#!/bin/bash
# Initial Setup
apt update && apt upgrade && apt install curl sysstat vim git software-properties-common build-essential -y

# Setup LCD Screen
echo "spidev" >> /etc/modules
echo "fbtft_device" >> /etc/modules
echo "spi_s3c64xx" >> /etc/modules
echo "options fbtft_device name=hktft9340 busnum=1 rotate=270" > /etc/modprobe.d/odroid-cloudshell.conf
echo -e "# blacklist IO Board Sensors\nblacklist ioboard_bh1780\nblacklist ioboard_bmp180\nblacklist ioboard_keyled" > /etc/modprobe.d/blacklist-odroid.conf
git clone https://github.com/mdrjr/cloudshell_lcd && ./cloudshell_lcd/build_deb.sh

# Setup CPU Throttling
wget https://raw.githubusercontent.com/mad-ady/odroid-cpu-control/master/odroid-cpu-control && chmod +x odroid-cpu-control
sudo chmod a-x /etc/init.d/ondemand # Disables default CPU Governor
./odroid-cpu-control -s -g "powersave" -m 200m -M 1.4G