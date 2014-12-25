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

        # console.log(data)
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
        # console.log(results)
        return callback err, results
    )

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

      @utorrent.call('add-url',
        {
            's': torrent.torrentUrl,
            'download_dir': 0,
            'path': '' # TODO: allow for customizing download directory
        },
        (err, result) =>
            # console.log("add-file", err, result)
            return callback err, result
      )

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
