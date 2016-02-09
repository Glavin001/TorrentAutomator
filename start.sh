#!/bin/bash

# Mount network shared drive
mkdir -p /mnt/Public
mount -t cifs -o username=root,password= //192.168.1.123/Public /mnt/Public
# Start transmission!
service transmission-daemon reload
service transmission-daemon start

# Start the application
npm start
