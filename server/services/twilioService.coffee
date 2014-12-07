twilio = require("twilio")
bot = require("../bot")
config = require("../../config.json")
client = twilio(config.twilio.accountSid, config.twilio.authToken)

module.exports = receive: (req, res) ->

  # console.log(req, res);

  # Respond empty to SMS.
  # Empty responses are not sent as SMS to sender.
  twiml = new twilio.TwimlResponse()
  res.send(twiml)

  from = req.body.From
  message = req.body.Body
  bot.generateResponse
    conversation: from
    message: message
    meta: req.body
  , (error, result) ->

    # console.log(error, result);
    if error
      body = error.message
    else
      body = result.response.plain

    client.sendMessage({
        to: from
        from: config.twilio.phone
        body: body
    }, (err, responseData) ->
        # console.log(err, responseData)
    )