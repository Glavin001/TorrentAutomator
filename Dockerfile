FROM resin/raspberrypi-node
ENV INITSYSTEM on
WORKDIR /usr/src/app
COPY package.json ./
COPY bower.json ./
COPY .bowerrc ./
COPY transmission_settings.json ./
COPY resin_config.json ./config.json
RUN npm install -g coffee-script && \
    npm install -g bower && \
    npm cache clean && \
    rm -rf /tmp/*
RUN npm install --verbose && \
    bower install --verbose --allow-root
RUN apt-get update && \
    apt-get install nfs-common && \
    apt-get install cifs-utils && \
    apt-get install transmission-daemon
RUN mount -t cifs -o username=root,password= //192.168.1.123/Public /mnt/Public || \
    usermod -a -G root debian-transmission || \
    cp transmission_settings.json /etc/transmission-daemon/settings.json || \
    service transmission-daemon reload || \
    service transmission-daemon start
COPY . ./
CMD npm start
