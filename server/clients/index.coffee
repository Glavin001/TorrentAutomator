config = require("../config")
TorrentClient = require "./base"
# Clients
TransmissionClient = require "./transmission"
uTorrentClient = require "./uTorrent"

# Currently configured and selected Torrent Client.
module.exports = class SelectedClient extends TorrentClient
  clients: null
  constructor: ->
    super
    @clients = []
    # Select client based on configration
    if config.transmission?
      #console.log("Adding Transmission TorrentClient")
      @clients.push(new TransmissionClient())
    if config.uTorrent?
      #console.log("Adding uTorrent TorrentClient")
      @clients.push(new uTorrentClient())
    if @clients.length > 1
      # TODO: Support multiple Clients
      console.warn("Only the first of #{@clients.length} Torrent Clients will be used.")
    else if @clients.length is 0
      console.warn("There are no available Torrent Clients. Please configure your `config.json`.")
    return @

  list: (callback) ->
    # TODO: Support multiple Clients
    client = @clients[0]
    if client?
      client.list callback

  addTorrent: (torrent, callback) ->
    # TODO: Support multiple Clients
    client = @clients[0]
    if client?
      client.addTorrent torrent, callback
