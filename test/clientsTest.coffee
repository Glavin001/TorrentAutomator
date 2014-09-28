assert = require "assert"
TransmissionClient = require "../server/clients/transmission"
client = new TransmissionClient()

describe "Clients", () ->
  describe "Transmission", ->
    it "should be tv show", () ->
      torrent = {
        category: "TV Shows"
        title: "Doctor Who 2005 S08E06 HDTV x264-TLA [eztv]"
      }
      d = client.getDownloadDirForTorrent(torrent)
      console.log(d)

    it "should be movie", () ->
      torrent = {
        category: "Movies"
        title: "The Maze Runner 2014 Cam x264 AAC REsuRRecTioN"
      }
      d = client.getDownloadDirForTorrent(torrent)
      console.log(d)

    it "should not be tv show", () ->
      torrent = {
        category: "TV Shows"
        title: "Doctor Who Season (2005) 1-7 DVDRip"
      }
      d = client.getDownloadDirForTorrent(torrent)
      console.log(d)
