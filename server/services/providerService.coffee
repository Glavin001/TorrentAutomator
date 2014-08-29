Providers = require "../providers/"

module.exports =
  setup: (app) ->
    # Setup
    @providers = new Providers()

  find: (params, callback) ->
    # console.log(params);
    query = params.query
    # console.log('query: ', query);
    # Set search Query parameter
    @providers.search query.query, {}, (error, data) ->
      callback error, data
