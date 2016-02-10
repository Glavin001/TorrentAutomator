async = require "async"
Command = require "./base"
TorrentClient = require("../../clients/")
urlRegex = require('url-regex')
URLTorrentProvider = require '../../providers/url'

# Setup
module.exports = class DownloadURLTorrentCommand extends Command
  constructor: ->
    super
    @client = new TorrentClient()
    @torrentProvider = new URLTorrentProvider()
    return @
  help: "Download <torrent URL, URL,...>"
  filter: urlRegex()
  run: (input, context, callback) ->
    self = this

    # console.log(input, context);
    query = input.message
    torrentURLs = query.match(self.filter)

    @torrentProvider.search torrentURLs, {}, (err, torrents) =>
      # console.log(err, torrents)

      # Create tasks list
      tasks = []
      downloads = {
        successful: []
        errored: []
        notFound: []
      }
      # Process selected Torrents and add them to be downloaded
      for torrent in torrents
        ((torrent) => (
          # Add task
          tasks.push (cb) =>
            title = torrent.title
            # Check if exists
            unless torrent
              downloads.notFound.push(title)
              return callback(null, selection)

            # Download Torrent
            @client.addTorrent torrent, (error, result) ->
              # console.log(error, result)
              if (error)
                downloads.errored.push(title)
              else
                downloads.successful.push(title)
              return cb(null, torrent)
        ))(torrent)

      # Run all tasks in parallel
      # console.log(tasks)
      async.series tasks, (err, torrent) ->
        # console.log "done", err, allSelections
        return callback err, null if err

        message = "Successfully started downloading " + \
          "#{downloads.successful.length} Torrent(s) " + \
          "(#{downloads.successful.join(', ')})"

        message += (if (downloads.errored.length > 0) then " Errors occurred on Torrent(s) #{downloads.errored.join(', ')}." else "")

        message += (if (downloads.notFound.length > 0) then " No Torrent found for selection(s) #{downloads.notFound.join(', ')}." else "")

        response = response:
          plain: message
        return callback err, response


