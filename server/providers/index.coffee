async = require "async"
BaseProvider = require "./base"
Kickass = require "./kickass"
EZTV = require "./eztv"

module.exports = class Providers extends BaseProvider
    allProviders: [
      new EZTV()
      new Kickass()
    ]
    search: (query, options, callback) ->
      # console.log "search", query, options
      # Create tasks list
      tasks = []
      # Iterate through allProviders
      for p in @allProviders
        ((provider) -> (
            # console.log('provider')
            # Add task
            tasks.push (cb) ->
              # Run search with current provider
              provider.search query, options, cb
        ))(p)
      # Run all tasks in parallel
      # console.log(tasks)
      async.parallel tasks, (err, allResults) ->
        # console.log "done", err, allResults
        results = [].concat.apply([], allResults)
        return callback err, results
