eztvQuery = require('eztv-query')
Provider = require "./base"
Torrent = require "../torrent"

module.exports = class EZTVProvider extends Provider
    search: (query, options, callback) ->
        # Set search Query parameter
        return eztvQuery(query, {
            returnAll: true
        }, (error, episodes) ->
            # console.log(error, episodes)
            return callback error, [] if error
            torrents = []
            for episode in episodes
                t = new Torrent \
                    title: episode.title,
                    torrentUrl: "http:#{episode.torrentURL}",
                    link: "https://eztv.it#{episode.url}",
                    verified: true,
                    seeders: undefined,
                    leechers: undefined,
                    size: undefined,
                    dateCreated: undefined,
                    hash: undefined,
                    category: "TV Shows",
                    meta: episode
                torrents.push t
            return callback null, torrents
        )
        