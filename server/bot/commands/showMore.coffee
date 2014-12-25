Command = require "./base"
TorrentClient = require("../../clients/")
SearchForTorrentsCommand = require "./searchForTorrents"

# Setup
module.exports = class ShowMoreCommand extends Command
    help: "Show more"
    regex: new RegExp("^((([sS]how)|([lL]ist)) )?(([nN]ext)|([mM]ore)).*$")
    filter: (input, context, callback) =>
        callback @regex.test(input.message) && !!context.foundTorrents
    run: (input, context, callback) ->
        # Get search results
        results = context.foundTorrents ? []
        maxResults = context.page.size ? 5
        # List the available Torrents
        start = context.page.end ? 0
        end = Math.min(start+maxResults, results.length)
        # Check if there are any more Torrents to list
        # console.log(results, start, end)
        if start < end
            # Init message
            message = "Here are the Torrents from #{start+1} to #{end} of #{results.length}:\n"
            # Build Torrent list in message
            while start < end
                torrent = results[start]
                message += SearchForTorrentsCommand.torrentToMessage(start, torrent)
                start++
        else
            message = "There are no more Torrents to list."
        # Create response
        response = response:
            plain: message
        # Save Torrents to context
        context.foundTorrents = results
        # Reset starting
        context.page.start = start
        context.page.end = end
        # return
        return callback null, response
