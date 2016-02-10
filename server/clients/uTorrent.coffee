uTorrentAPI = require("utorrent-api")
config = require("../config")
TorrentClient = require "./base"
episode = require "episode"
Mustache = require "mustache"
request = require("request")

module.exports = class uTorrentClient extends TorrentClient
  utorrent: null
  constructor: ->
    super
    @utorrent = new uTorrentAPI(config.uTorrent.host, config.uTorrent.port)
    @utorrent.setCredentials(config.uTorrent.username, config.uTorrent.password)
    return @

  list: (callback) ->
    @utorrent.call("list", (err, data) ->
      return callback(err, null) if err
      results = {
        torrents: []
      }
      for datum in data.torrents
        torrent = {
          name: datum[2]
          percentDone: datum[4]/1000
          eta: datum[10]
        }
        results.torrents.push(torrent)
      return callback err, results
    )

  addTorrent: (torrent, callback) ->
    options = {}
    # Check if custom download-dir
    downloadDir = @getDownloadDirForTorrent(torrent)
    if downloadDir?
      options['download_dir'] = downloadDir.basePath
      options['path'] = downloadDir.subPath
    # Check for missing Torrent URL
    unless torrent.torrentUrl
      callback new Error("Missing Torrent URL field."), null
    else
      options['s'] = torrent.torrentUrl
      @utorrent.call('add-url', options, (err, result) =>
        # console.log("add-file", err, result)
        return callback err, result
      )

  getDownloadDirForTorrent: (torrent) ->
    downloadDirs = config.downloadDirs
    def = { # Default
      "basePath": 0,
      "subPath": ""
      }
    if downloadDirs
      downloadDir = downloadDirs[torrent.category]
      # console.log(typeof downloadDir, torrent.category)
      renderPathForTorrent = (torrent, template, defDir) ->
        title = torrent.title
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

      if typeof downloadDir is "object"
        basePath = downloadDir.basePath || 0
        template = downloadDir.template || ""
        defDir = downloadDir.default || ""
        subPath = renderPathForTorrent(torrent, template, defDir)
        return {
          "basePath": basePath
          "subPath": subPath
        }
      else if typeof downloadDir is "number"
        # Specifying Base-Path
        return {
          "basePath": downloadDir
          "subPath": ""
        }
      else if typeof downloadDir is "string"
        # Specifiying Sub-Path
        basePath = 0 # Default
        subPath = renderPathForTorrent(torrent, downloadDir, "")
        return {
          "basePath": basePath,
          "subPath": subPath
        }
      else
        # Unsupported
        console.warn("Unsupported 'downloadDirs' configuration for category #{torrent.category}. Please check that.")
        return def
    else
      return def
