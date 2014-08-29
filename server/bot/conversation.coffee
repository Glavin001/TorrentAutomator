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

      # console.log('commands', commands);
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
    console.log Commands
    async.filter Commands, ((command, callback) ->
      console.log command

      # Check if command is applicable
      checkFun = command.check
      regex = command.regex

      # Check for Regex test
      # console.log(typeof message, message);

      # Failed
      return callback(false)  if regex and not regex.test(message)

      # Check function
      if checkFun
        checkFun input, context, callback
      else
        callback true
    ), (results) ->

      # results now equals an array of the existing files
      # console.log(results);
      callback results

    return
