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
        # Force scope with closure
        #do (p, query, options) ->
        #  (p, q, op) ->
        #    console.log p, q, op
            # Add task
        tasks.push (cb) ->
              # Run search with current provider
        #      console.log q, op
        #      p.search q, op, cb
          p.search query, options, cb
      # Run all tasks in parallel
      async.parallel tasks, (err, results) ->
        # console.log "done", err, results
        return callback err, results
