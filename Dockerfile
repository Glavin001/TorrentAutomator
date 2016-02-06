FROM resin/raspberrypi-node
ENV INITSYSTEM on
COPY . /usr/src/app
WORKDIR /usr/src/app
RUN npm install
CMD npm start

