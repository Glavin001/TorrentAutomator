async = require "async"
BaseProvider = require "./base"
Kickass = require "./kickass"

module.exports = class Providers extends BaseProvider
    allProviders: [
      new Kickass()
    ]
    search: (query, options, callback) ->
      # console.log "search", query, options
      # Create tasks list
      tasks = []
      # Iterate through allProviders
      for p in @allProviders
        # Add task
        tasks.push (cb) ->
          # Run search with current provider
          p.search query, options, cb
      # Run all tasks in parallel
      async.parallel tasks, (err, allResults) ->
        # console.log "done", err, allResults
        results = [].concat.apply([], allResults)
        return callback err, results
