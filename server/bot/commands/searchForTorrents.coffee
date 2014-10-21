Command = require "./base"
TorrentProvider = require "../../providers/"

# Setup
module.exports = class SearchForTorrentsCommand extends Command
  kickass: null
  maxResults: 5
  filter: new RegExp("^[sS]earch for (.*)")
  constructor: () ->
    @torrentProvider = new TorrentProvider()
  run: (input, context, callback) =>
    # console.log(input);
    query = input.message
    query = query.match(@filter)[1]
    # console.log(query);
    @torrentProvider.search query, {}, (err, results) =>
      # console.log(results);
      # List the available Torrents
      len = Math.min(@maxResults, results.length)
      # Init message
      message = "Here are the top #{len} Torrents:\n"
      # Build Torrent list in message
      i = 0
      while i < len
        torrent = results[i]
        downloadSizeInMB = torrent.size / 1000 / 1000
        stats = ((if torrent.verified then "Verified and " else "")) +
          "#{Math.round(downloadSizeInMB * 100) / 100} MB with " +
          "#{torrent.seeders} seeders and " +
          "#{torrent.leechers} leechers"
        message += (i + 1) + ". " + torrent.title + " (" + stats + ") \n"
        i++
      # Create response
      response = response:
        plain: message
      # Save Torrents to context
      context.foundTorrents = results
      # return
      return callback err, response
