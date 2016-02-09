twilio = require("twilio")
bot = require("../bot")
config = require("../config")
TWILIO_PHONE = config.twilio.phone
TWILIO_ACCOUNT_SID = config.twilio.accountSid
TWILIO_AUTH_TOKEN = config.twilio.authToken
if not (TWILIO_PHONE and TWILIO_ACCOUNT_SID and TWILIO_AUTH_TOKEN)
  throw new Error "Please configure Twilio"
client = twilio(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)

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
      from: TWILIO_PHONE
      body: body
    }, (err, responseData) ->
        # console.log(err, responseData)
    )