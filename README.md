[TorrentAutomator](https://github.com/Glavin001/TorrentAutomator) [![Build Status](https://travis-ci.org/Glavin001/TorrentAutomator.svg)](https://travis-ci.org/Glavin001/TorrentAutomator)
================

> Automate the task of [searching for Torrents](http://kickass.to/) and sending them to [Transmission](https://www.transmissionbt.com/) to download.

## Installation

### 1. Download the Project

Clone it with Git, and update with `git pull`.

### 2. Install [Node.js](http://nodejs.org/) and Dependencies

See [Node.js's website](http://nodejs.org/).

After installing [Node.js](http://nodejs.org/),
install [Bower](http://bower.io/) and
[CoffeeScript](http://coffeescript.org/).

```bash
npm install -g bower
npm install -g coffeescript
```

Now that you have [Node.js](http://nodejs.org/)
and [Bower](http://bower.io/), you can install the dependencies.
Change into this downloaded project directory and run:

```bash
npm install
bower install
```

### 3. Configure Your Server

Create `config.json` in the project's directory.

Here is a sample `config.json`:

```json
{
    "server": {
      "port": 8000
    },
    "transmission": {
        "host": "localhost",
        "port": 9091,
        "username": "USERNAME",
        "password": "PASSWORD"
    },
    "twilio": {
      "phone": "15555555555",
      "accountSid": "TWILIO_ACCOUNT_SID",
      "authToken": "TWILIO_AUTH_TOKEN"
    },
    "downloadDirs": {
      "Movies": "/Media/Movies",
      "TV Shows": {
        "template": "/Media/TV Shows/{{show_name}}/Season {{season}}",
        "default": null
      }
    }
}
```

Setup your [Transmission server](https://www.transmissionbt.com/) and
change the above Transmission configuration.

Sign up for [Twilio](https://www.twilio.com) and
change the above Twilio configuration.
Configure your Twilio's phone number to send text messages to
your TorrentAutomator server.

## Usage

After you're completely done the setup above
you can start the [TorrentAutomator](https://github.com/Glavin001/TorrentAutomator) server.

```bash
coffee server/
```

Or

```bash
./server/index.coffee
```

The you can either:

### Connect to the Web app

In your web-browser go to `http://localhost:8000/`.
Modify your address for the correct server IP address and
port number as configured above.

### Text the Server with Twilio

Text your Twilio phone number with commands such as the following:

```
Search for <torrent search keyword>
```

```
Download <selection number from previous "Search for" request>
```

```
Show downloads
```
