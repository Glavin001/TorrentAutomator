async = require("async")
Commands = require "./commands/"

module.exports = class Conversation
  constructor: (@from) ->
  history: []
  context: {}
  respond: (input, callback) ->
    @processInput input, @context, callback
    return
  processInput: (input, context, callback) ->
    @getCommands input, context, (commands) ->
      # Get first available command
      command = commands[0]
      # Check if command found
      unless not command
        # Execute command
        command.run input, context, callback
      else
        # Command not found
        callback new Error("Could not find an applicable command."), null

  getCommands: (input, context, callback) ->
    message = input.message
    async.filter Commands, ((command, callback) ->
      # Check if command is applicable
      filter = command.filter
      # Check if function
      if typeof filter is "function"
        # Treat as function and run filter check
        filter input, context, callback
      else if filter instanceof RegExp or typeof filter is "string"
        # Check for Regex test
        # Failed
        regex = new RegExp(filter)
        if regex and not regex.test(message)
          return callback(false)
        else
          return callback(true)
      else
        throw new Error "Unsupported filter: #{filter}"
    ), (results) ->
      # results now equals an array of the existing files
      # console.log(results);
      callback results
    return
