#!/bin/bash
# Author: kennyparsons
# Usage: linux-64bit, running as a non-root user

runasroot=1
origindir=$(dirname "$0")
echo $origindir

cd /tmp
echo $(date "+%Y/%m/%d %H:%M:%S")" INFO  : starting cloudflared installation"
echo $(date "+%Y/%m/%d %H:%M:%S")" INFO  : downloading latest version"
wget https://bin.equinox.io/c/VdrWdbjqyF/cloudflared-stable-linux-amd64.deb

echo $(date "+%Y/%m/%d %H:%M:%S")" INFO  : installing latest version"
sudo apt-get install ./cloudflared-stable-linux-amd64.deb
cloudflared -v

echo $(date "+%Y/%m/%d %H:%M:%S")" INFO  : creating cloudflared user"
sudo useradd -s /usr/sbin/nologin -r -M cloudflared

cd $origindir
pwd
echo $(date "+%Y/%m/%d %H:%M:%S")" INFO  : creating cloudflared config"
sudo cp ./cloudflared.conf /etc/default/cloudflared

echo $(date "+%Y/%m/%d %H:%M:%S")" INFO  : setting permissions"
sudo chown cloudflared:cloudflared /etc/default/cloudflared
sudo chown cloudflared:cloudflared /usr/local/bin/cloudflared

echo $(date "+%Y/%m/%d %H:%M:%S")" INFO  : creating cloudflared.service"
sudo cp ./cloudflared.service /etc/systemd/system/cloudflared.service

echo $(date "+%Y/%m/%d %H:%M:%S")" INFO  : eabling cloudflared.service"
sudo systemctl enable cloudflared.service

echo $(date "+%Y/%m/%d %H:%M:%S")" INFO  : starting cloudflared.service"
sudo systemctl start cloudflared
sudo systemctl status cloudflared

echo $(date "+%Y/%m/%d %H:%M:%S")" INFO  : creating cloudflared update script"
sudo cp ./update-cloudflared /usr/local/bin/update-cloudflared
sudo chmod +x /usr/local/bin/update-cloudflared

echo $(date "+%Y/%m/%d %H:%M:%S")" INFO  : cloudflared has been enabled and is listening at port 5053"
echo $(date "+%Y/%m/%d %H:%M:%S")" INFO  : to update cloudflared, simply run update-cloudflared"

exit
