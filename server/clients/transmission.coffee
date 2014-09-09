Transmission = require("transmission")
config = require("../../config.json")
TorrentClient = require "./base"

module.exports = class TranmissionClient extends TorrentClient
  transmission: null
  constructor: ->
    super
    @transmission = new Transmission(config.transmission)
    return @

  list: (callback) ->
    @transmission.active (err, result) ->
      callback err, result

  addTorrent: (torrent, callback) ->
    options = {}
    # Check if custom download-dir
    downloadDir = @getDownloadDirForTorrent(torrent)
    if downloadDir?
      options['download-dir'] = downloadDir
    # Check for missing Torrent URL
    unless torrent.torrentUrl
      callback new Error("Missing Torrent URL field."), null
    else
      @transmission.addUrl torrent.torrentUrl, options, (err, result) ->
        callback err, result

  getDownloadDirForTorrent: (torrent) ->
    downloadDirs = config.downloadDirs
    if downloadDirs
      return downloadDirs[torrent.category]
    else
      return null
