FROM resin/raspberrypi-node
ENV INITSYSTEM on
WORKDIR /usr/src/app
COPY package.json ./
COPY . ./
RUN /bin/bash ./setup.sh
CMD npm start

