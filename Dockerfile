FROM resin/raspberrypi-node
ENV INITSYSTEM on
WORKDIR /usr/src/app
COPY package.json ./
RUN /bin/bash setup.sh
COPY . ./
CMD npm start

