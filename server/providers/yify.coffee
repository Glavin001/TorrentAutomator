Provider = require "./base"
Torrent = require "../torrent"
request = require "request"

module.exports = class YIFYProvider extends Provider
  listUri: "https://yts.to/api/list.json"
  sortBy: "seed"
  limit: 20
  search: (query, options, callback) ->
    # See API docs: https://yts.to/api#listDocs
    uri = "#{@listUri}?sort=#{@sortBy}&limit=#{@limit}&keywords=#{query}"
    # Send request
    request({
        method: 'GET'
        uri: uri
        }, (err, response, body) =>
            return callback(err, []) if err

            try
                # Parse body
                data = JSON.parse(body)
            catch e
                # API does not always return JSON
                # In the case of a server error,
                # an entire HTML webpage is returned!
                return callback(null, [])
                # Fail silently

            # Check for failures
            if data.status is "fail"
                # Fail silently: likely because "No movies found"
                return callback(null, [])

            movieList = data.MovieList
            torrents = []
            for movie in movieList
                t = new Torrent \
                    title: movie.MovieTitle,
                    torrentUrl: movie.TorrentUrl,
                    link: movie.MovieUrl,
                    verified: true,
                    seeders: movie.TorrentSeeds,
                    leechers: movie.TorrentPeers,
                    size: movie.SizeByte,
                    dateCreated: movie.DateUploaded,
                    hash: movie.TorrentHash,
                    category: "Movies",
                    meta: movie
                torrents.push t

            return callback null, torrents

    )

