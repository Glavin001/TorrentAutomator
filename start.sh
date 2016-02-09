#!/bin/bash

# Mount network shared drive
mkdir -p /mnt/Public
mount -t cifs -o username=root,password=,guest,uid=1000,gid=1000,rw,file_mode=0777,dir_mode=0777,sfu //192.168.1.123/Public /mnt/Public

# Start transmission!
service transmission-daemon reload
service transmission-daemon start

# Start the application
npm start
