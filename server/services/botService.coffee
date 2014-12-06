bot = require("../bot")
module.exports = create: (data, params, callback) ->

  # console.log('create', data, params);
  from = data.from
  message = data.message
  meta = data
  bot.generateResponse
    conversation: from
    message: message
    meta: data
  , (error, result) ->
    if error
        return callback null, "Please try again later. Error: #{error.message}"
    else
        return callback null, result
  return
