async = require "async"
Command = require "./base"
TorrentClient = require("../../clients/")

# Setup
module.exports = class DownloadTorrentCommand extends Command
  constructor: ->
    super
    @client = new TorrentClient()
    return @
  help: "Download <selection #, #,...>"
  regex: new RegExp("^[dD]ownload ((?:\\d+\\s*,\\s*)*(?:\\d+)).*$")
  filter: (input, context, callback) =>
    # console.log(input, @regex, context, context.foundTorrents);
    callback @regex.test(input.message) && !!context.foundTorrents
  run: (input, context, callback) ->
    self = this

    # console.log(input, context);
    query = input.message
    selections = query.match(self.regex)[1]

    # Split on comma
    sp = selections.split(",")
    
    selectedTorrents = []
    for s in sp
        selection = parseInt(s)
        # console.log(selection, s, sp)
        # console.log(selection);
        if isNaN(selection)
          # User error
          return callback(null,
            response:
              plain: "Sorry, \"#{s}\" in \"#{query}\" is not a selection number."
          )
        # Add Torrent selection to be processed
        selectedTorrents.push(selection)

    # Create tasks list
    tasks = []
    downloads = {
        successful: []
        errored: []
        notFound: []
    }
    # Process selected Torrents and add them to be downloaded
    for selection in selectedTorrents
        ((selection) => (
            # Add task
            tasks.push (cb) =>

                # Get Torrent
                # Change selection from 1-based index to 0-based
                torrent = context.foundTorrents[selection-1]

                # Check if exists
                unless torrent
                  downloads.notFound.push(selection)
                  return callback(null, selection)

                # Download Torrent
                @client.addTorrent torrent, (error, result) ->
                    # console.log(error, result);
                    if (error)
                        downloads.errored.push(selection)
                    else
                        downloads.successful.push(selection)
                    return cb(null, selection)  

        ))(selection)

    # Run all tasks in parallel
    # console.log(tasks)
    async.series tasks, (err, allSelections) =>
        # console.log "done", err, allSelections
        return callback err, null if err

        message = "Successfully started downloading #{downloads.successful.length} Torrent(s) " + \
        "(#{downloads.successful.join(', ')})"

        message += (if (downloads.errored.length > 0) then " Errors occurred on Torrent(s) #{downloads.errored.join(', ')}." else "")
        
        message += (if (downloads.notFound.length > 0) then " No Torrent found for selection(s) #{downloads.notFound.join(', ')}." else "")

        response = response:
                        plain: message
        return callback err, response

