FROM resin/raspberrypi-node
ENV INITSYSTEM on
WORKDIR /usr/src/app
COPY package.json ./
RUN source setup.sh
COPY . ./
CMD npm start

