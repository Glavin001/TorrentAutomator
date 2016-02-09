FROM resin/raspberrypi-node
ENV INITSYSTEM on
WORKDIR /usr/src/app

# Install more dependencies
RUN apt-get update && \
  apt-get install nfs-common && \
  apt-get install cifs-utils && \
  apt-get install transmission-daemon

# Install NPM global dependencies
RUN npm install -g coffee-script && \
  npm install -g bower && \
  npm cache clean && \
  rm -rf /tmp/*

# Install NPM packages
COPY package.json ./
RUN npm install --verbose

# Install Bower packages
COPY bower.json .bowerrc ./
RUN bower install --verbose --allow-root

# Configure Transmission
COPY transmission_settings.json ./
COPY resin_config.json ./config.json
RUN usermod -a -G root debian-transmission ; \
    cp transmission_settings.json /etc/transmission-daemon/settings.json

# Copy the application project
COPY . ./

# Run on device
CMD /bin/bash start.sh
