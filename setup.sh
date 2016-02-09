#!/bin/bash

echo "Installing dependencies"
npm install -g coffee-script
npm install -g bower
npm install --verbose
bower install --verbose

apt-get update
apt-get install nfs-common
apt-get install cifs-utils
apt-get install transmission-daemon

echo "Mount network shared drive"
mount -t cifs -o username=root,password= //192.168.1.123/Public /mnt/Public
echo "Configure Transmission"
usermod -a -G root debian-transmission
cp transmission_settings.json /etc/transmission-daemon/settings.json
echo "Starting Transmission"
service transmission-daemon reload
service transmission-daemon start
echo "Configure Application"
cp resin_config.json config.json
