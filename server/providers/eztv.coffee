eztvQuery = require('eztv-query')
Provider = require "./base"
Torrent = require "../torrent"

module.exports = class EZTVProvider extends Provider
  search: (query, options, callback) ->
    # Set search Query parameter
    return @kickass
    .setQuery(query)
    .setSort(
      field: "seeders"
      sorder: "desc"
    ).run (error, data) ->
      return callback error, [] if error
      torrents = []
      for datum in data
        t = new Torrent \
            title: datum.title,
            torrentUrl: datum.torrentLink,
            link: datum.link,
            verified: datum.verified,
            seeders: datum.seeds,
            leechers: datum.leechs,
            size: datum.size,
            dateCreated: datum.pubDate,
            hash: datum.hash,
            category: datum.category,
            meta: datum
        torrents.push t
      return callback null, torrents
