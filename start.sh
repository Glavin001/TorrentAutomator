#!/bin/bash

# Mount network shared drive
mount -t cifs -o username=root,password= //192.168.1.123/Public /mnt/Public
# Copy transmission settings
cp transmission_settings.json /etc/transmission-daemon/settings.json
# Start transmission!
service transmission-daemon reload
service transmission-daemon start

# Start the application
npm start
