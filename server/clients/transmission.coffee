Transmission = require("transmission")
config = require("../../config.json")
TorrentClient = require "./base"
episode = require "episode"
Mustache = require "mustache"

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
      downloadDir = downloadDirs[torrent.category]
      if typeof downloadDir is "object"
        title = torrent.title
        template = downloadDir.template || null
        defDir = downloadDir.default || null
        e = episode(title)
        # Check if it was properly parse
        if e.matches.length > 0
          context = e
          e.show_name = title.split(e.matches[0])[0].trim()
          e.download_date = new Date()
          e.title = title
          downloadDir = Mustache.render(template, context);
          return downloadDir
        else
          return defDir
      else
        return downloadDir
    else
      return null
