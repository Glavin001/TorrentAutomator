async = require("async")
Commands = require "./commands/"
Help = require "./commands/help"

# Add the Help command
commands = Commands.concat([new Help()])

module.exports = class Conversation
  constructor: (@from) ->
  history: []
  context: {}
  respond: (input, callback) ->
    @processInput input, @context, callback
    return
  processInput: (input, context, callback) ->
    # Trim whitespace from input message
    @getCommands input, context, (commands) ->
      # Get first available command
      command = commands[0]
      # Check if command found
      unless not command
        # Execute command
        command.run input, context, callback
      else
        # Command not found
        callback new Error("Could not find an applicable command for \"#{input.message}\". \"Show commands\" to see your options."), null

  getCommands: (input, context, callback) ->
    # console.log("Before msg: #{input.message}")
    input.rawMessage = input.message # Backup original, raw message
    input.message = @trim11(input.message) # Trim whitespace in message
    # console.log("After msg: #{input.message}")
    message = input.message # Cache to speed up lookups

    async.filter commands, ((command, callback) ->
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

  # Source: http://stackoverflow.com/a/3000784/2578205
  trim11: (str) ->
      str = str.replace(/^\s+/, "")
      i = str.length - 1

      while i >= 0
        if /\S/.test(str.charAt(i))
          str = str.substring(0, i + 1)
          break
        i--
      str