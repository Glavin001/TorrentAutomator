config = require("../../config.json")
TorrentClient = require "./base"
# Clients
TransmissionClient = require "./transmission"

# Currently configured and selected Torrent Client.
module.exports = class SelectedClient extends TorrentClient
  client: null
  constructor: ->
    super
    # Select client based on configration
    @client = new TransmissionClient() # TEMP: Only have TransmissionClient
    return @

  list: (callback) ->
    @client.list callback

  addTorrent: (torrent, callback) ->
    @client.addTorrent torrent, callback
