FROM resin/raspberrypi-node
ENV INITSYSTEM on
WORKDIR /usr/src/app
COPY package.json ./
COPY setup.sh ./
COPY transmission_settings.json /etc/transmission-daemon/settings.json
COPY resin_config.json ./config.json
RUN /bin/bash ./setup.sh
COPY . ./
CMD npm start
