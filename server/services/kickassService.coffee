Kickass = require("node-kickass-json")
module.exports =
  kickass: null
  setup: (app) ->

    # Setup
    # console.log('Setup Kickass');
    @kickass = new Kickass()
    return

  find: (params, callback) ->

    # console.log(params);
    query = params.query

    # console.log('query: ', query);
    # Set search Query parameter
    @kickass.setQuery(query.query).setSort(
      field: query.field or "seeders"
      sorder: query.sorder or "desc"
    ).run (error, data) ->
      callback error, data

    return

# get: function(id, params, callback) {
#   this.transmission.get(id, function(err, result) {
#       if (err) {
#           return callback(err, result);
#       }
#       console.log('bt.get returned ' + result.torrents.length + ' torrents');
#       return callback(result.torrents);
#   });
# }
