#!/bin/bash
# Initial Setup
apt update && apt upgrade && apt install samba samba-common checkinstall rpm curl gawk bc sysstat vim git software-properties-common build-essential -y

# Setup LCD Screen
echo -e '\033[9;0]' > /dev/tty1
echo -e 'spi_s3c64xx\nspidev\nfbtft_device' >> /etc/modules
echo "options fbtft_device name=hktft9340 busnum=1 rotate=270" > /etc/modprobe.d/odroid-cloudshell.conf
echo -e "# blacklist IO Board Sensors\nblacklist ioboard_bh1780\nblacklist ioboard_bmp180\nblacklist ioboard_keyled\n# LCD Touchscreen driver\nblacklist ads7846" > /etc/modprobe.d/blacklist-odroid.conf
sed -i -e 's/console=tty1/console=tty1 consoleblank=0/g' /media/boot/boot.ini
# Setup CPU Throttling
wget https://raw.githubusercontent.com/mad-ady/odroid-cpu-control/master/odroid-cpu-control && chmod +x odroid-cpu-control
./odroid-cpu-control -s -g "powersave" -m 200m -M 1.4G
# Persistent CPU Throttling
sed -i '13i\\n./usr/bin/odroid-cpu-control -s -g powersave -m 200m -M 1.4G' /etc/rc.local
mv odroid-cpu-control /usr/bin/odroid-cpu-control
# Setup CloudShell LCD Information Display
git clone https://github.com/digital-dev/cloudshell_lcd && ./cloudshell_lcd/build_deb.sh