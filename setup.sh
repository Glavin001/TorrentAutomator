#!/bin/bash

echo "Installing dependencies"
npm install -g coffee-script
npm install -g bower
npm install --verbose
bower install --verbose --allow-root

apt-get update
apt-get install nfs-common
apt-get install cifs-utils
apt-get install transmission-daemon

# Clean cache
npm cache clean
rm -rf /tmp/*

echo "Mount network shared drive"
mount -t cifs -o username=root,password= //192.168.1.123/Public /mnt/Public
echo "Configure Transmission"
usermod -a -G root debian-transmission
echo "Starting Transmission"
service transmission-daemon reload
service transmission-daemon start
