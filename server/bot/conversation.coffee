commands = require("./commands")
module.exports = (from) ->
  self = this
  self.history = []
  self.context = {}
  self.respond = (input, callback) ->
    commands.processInput input, self.context, callback
    return

  return
