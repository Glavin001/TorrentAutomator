readTorrent = require 'read-torrent'
Provider = require "./base"
Torrent = require "../torrent"
async = require "async"

module.exports = class URLTorrentProvider extends Provider
  search: (urls, options, callback) ->
    # Convert to array of URLs
    if typeof urls is "string"
      query = [urls]

    console.log('url torrent urls', urls)

    async.map(urls, (url, cb) ->
      readTorrent(url, (error, torrent) ->
        return cb(error, null) if error

        t = new Torrent \
            title: torrent.name,
            torrentUrl: url,
            link: url,
            verified: false,
            seeders: 0,
            leechers: 0,
            size: torrent.length,
            dateCreated: new Date(torrent.created),
            hash: torrent.infoHash,
            category: null,
            meta: torrent

        return cb null, t
      )
    , callback)