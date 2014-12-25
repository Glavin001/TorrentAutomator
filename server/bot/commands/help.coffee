Command = require "./base"
Commands = require "./index"

# Setup
module.exports = class HelpCommand extends Command
  help: "Show commands"
  filter: new RegExp("^(([hH]elp)|(([sS]how)|([lL]ist))( (my|all) )? [cC]ommands).*$")
  run: (input, context, callback) ->
    self = this
    message = "You have #{Commands.length} commands:\n"
    for command in Commands
        msg = command.help
        msg ?= command.constructor.name
        message += "- #{msg}\n"
    response = response:
      plain: message
    callback null, response
