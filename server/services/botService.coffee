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
      message = "Please try again later. Error: #{error.message}"
      response = response:
        plain: message
      return callback null, response
    else
      return callback null, result
  return
