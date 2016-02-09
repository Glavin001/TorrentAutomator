FROM resin/raspberrypi-node
ENV INITSYSTEM on
WORKDIR /usr/src/app
COPY package.json ./
COPY bower.json ./
COPY .bowerrc ./
COPY transmission_settings.json ./
COPY resin_config.json ./config.json
# Install NPM global dependencies
RUN npm install -g coffee-script && \
    npm install -g bower && \
    npm cache clean && \
    rm -rf /tmp/*
# Install application dependencies/packages
RUN npm install --verbose && \
    bower install --verbose --allow-root
# Install more dependencies
RUN apt-get update && \
    apt-get install nfs-common && \
    apt-get install cifs-utils && \
    apt-get install transmission-daemon
# Change appropriate permissions
# And Copy transmission settings
RUN usermod -a -G root debian-transmission ; \
    cp transmission_settings.json /etc/transmission-daemon/settings.json
COPY . ./
# Run on device - Start application
CMD /bin/bash start.sh
