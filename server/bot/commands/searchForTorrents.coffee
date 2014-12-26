Command = require "./base"
TorrentProvider = require "../../providers/"

# Setup
module.exports = class SearchForTorrentsCommand extends Command
    kickass: null
    maxResults: 5
    help: "Search for <search keywords>"
    filter: new RegExp("^[sS]earch for (.*)")
    constructor: () ->
        @torrentProvider = new TorrentProvider()
    run: (input, context, callback) =>
        # console.log(input);
        query = input.message
        query = query.match(@filter)[1]
        # console.log(query);
        @torrentProvider.search query, {}, (err, results) =>
          # console.log('searchForTorrents', err, results);
          return callback(err, null) if err
          # List the available Torrents
          len = Math.min(@maxResults, results.length)
          # Check if any torrents found
          if len is 0
              message = "No Torrents found for search \"#{query}\"."
          else
              # Torrents found
              # Init message
              message = "Here are the top #{len} of #{results.length} Torrents:\n"
              # Build Torrent list in message
              i = 0
              while i < len
                torrent = results[i]
                message += @constructor.torrentToMessage(i, torrent)
                i++

          # Create response
          response = response:
            plain: message
          # Save Torrents to context
          context.foundTorrents = results
          # Reset starting
          context.page = {
            start: 0
            end: len
            size: @maxResults  
          }
          # return
          return callback null, response
    
    @torrentToMessage: (i, torrent) ->
        downloadSizeInMB = torrent.size / 1000 / 1000
        stats = ((if torrent.verified then "Verified" else "")) +
          (if (torrent.verified && \
            (not isNaN(downloadSizeInMB) \
            || (torrent.seeders && torrent.leechers) ) ) then " and " else "") +
          (if not isNaN(downloadSizeInMB) then "#{Math.round(downloadSizeInMB * 100) / 100} MB with " else "") +
          (if (torrent.seeders and torrent.leechers) then \
          ("#{torrent.seeders} seeders and " + \
          "#{torrent.leechers} leechers") \
          else "")
        return "#{i + 1}. #{torrent.title} (#{stats}) \n"
