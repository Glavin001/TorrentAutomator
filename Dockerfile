FROM resin/raspberrypi-node
ENV INITSYSTEM on
WORKDIR /usr/src/app
COPY package.json ./
RUN npm install --verbose
COPY . ./
CMD npm start

