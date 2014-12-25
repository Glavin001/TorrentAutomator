Transmission = require("transmission")
config = require("../config")
module.exports =
  transmission: null
  setup: (app) ->

    # Setup
    # console.log('Setup Transmission');
    # console.log(config.transmission);
    @transmission = new Transmission(config.transmission)
    return

  find: (params, callback) ->
    @transmission.active (err, result) ->
      callback err, result

    return

  get: (id, params, callback) ->
    @transmission.get id, (err, result) ->
      return callback(err, result)  if err

      # console.log('bt.get returned ' + result.torrents.length + ' torrents');
      callback result.torrents

    return

  create: (data, params, callback) ->
    console.log "create", data, params
    options = {}
    unless data.url
      callback new Error("Missing Torrent URL field."), null
    else
      @transmission.addUrl data.url, options, (err, result) ->
        callback err, result



  # update: function(id, data, params, callback) {},

  # patch: function(id, data, params, callback) {},
  remove: (id, params, callback) ->
    @transmission.remove id, (err) ->
      return callback(err, null)  if err

      # console.log('torrent was removed');
      callback null, true

    return
