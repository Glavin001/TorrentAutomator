Command = require "./base"
TorrentClient = require("../../clients/")
prettyMs = require("pretty-ms")

# Setup
module.exports = class ShowDownloadsCommand extends Command
  constructor: ->
    super
    @client = new TorrentClient()
    return @
  help: "Show downloads"
  filter: new RegExp("^(?=([sS]how)|([lL]ist)( (me|my))?( currently)? download(ing|s)).*$")
  run: (input, context, callback) ->
    self = this
    @client.list (error, result) ->
      if error
        callback error, null
      else
        # var message = JSON.stringify(result, undefined, 2);
        # console.log(result);
        torrents = result.torrents
        message = torrents.length + " active Torrent(s):\n"
        # List the available Torrents
        len = torrents.length
        i = 0
        while i < len
          torrent = torrents[i]
          # console.log(torrent);
          stats = undefined
          unless torrent.eta is -1
            eta = prettyMs(torrent.eta * 1000) + " remaining"
            perc = (Math.round((torrent.percentDone * 100) * 10) / 10) + "% downloaded"
            stats = perc + " with " + eta
          else
            stats = "Completed Downloading"
          message += (i + 1) + ". " + torrent.name + " (" + stats + ") \n"
          i++
        response = response:
          plain: message
        callback null, response
