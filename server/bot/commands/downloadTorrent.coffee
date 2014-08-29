Command = require "./base"
TorrentClient = require("../../clients/")

# Setup
module.exports = class DownloadTorrentCommand extends Command
  constructor: ->
    super
    @client = new TorrentClient()
    return @
  regex: new RegExp("^[dD]ownload ([0-9]*).*$")
  filter: (input, context, callback) =>
    # console.log(input, @regex, context, context.foundTorrents);
    callback @regex.test(input.message) && !!context.foundTorrents
  run: (input, context, callback) ->
    self = this

    # console.log(input, context);
    query = input.message
    selection = parseInt(query.match(self.regex)[1])

    # console.log(selection);
    if isNaN(selection)

      # User error
      return callback(null,
        response:
          plain: "Sorry, \"" + query + "\" is not a selection number."
      )

    # Change selection from 1-based index to 0-based
    selection--

    # Get Torrent
    torrent = context.foundTorrents[selection]

    # Check if exists
    unless torrent

      # User error
      message = "No Torrent found for selection " + selection + "+. "
      message += "Please search for a Torrent."
      response = response:
        plain: message

      return callback(null, response)

    # Modify to fit Transmission Service API
    torrent.url = torrent.torrentUrl
    @client.addTorrent torrent, (error, result) ->
      # console.log(error, result);
      if error
        callback error, null
      else
        message = "Successfully started downloading " + torrent.title
        response = response:
          plain: message
        callback null, response
