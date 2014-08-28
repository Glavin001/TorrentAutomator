twilio = require("twilio")
bot = require("../bot")
module.exports = receive: (req, res) ->

  # console.log(req, res);

  #   body:
  # { ToCountry: 'CA',
  #   ToState: 'Prince Edward Island',
  #   SmsMessageSid: 'SM360ef49e6e5b684e6876941808779f10',
  #   NumMedia: '0',
  #   ToCity: 'Nova Scotia',
  #   FromZip: '',
  #   SmsSid: 'SM360ef49e6e5b684e6876941808779f10',
  #   FromState: 'NS',
  #   SmsStatus: 'received',
  #   FromCity: 'HALIFAX',
  #   Body: 'Testeyyy',
  #   FromCountry: 'CA',
  #   To: '+19027071181',
  #   ToZip: '',
  #   MessageSid: 'SM360ef49e6e5b684e6876941808779f10',
  #   AccountSid: 'ACb08acfcdb50c00b820068d14fa4b5956',
  #   From: '+19022257035',
  #   ApiVersion: '2010-04-01' },
  from = req.body.From
  message = req.body.Body
  bot.generateResponse
    conversation: from
    message: message
    meta: req.body
  , (error, result) ->

    # console.log(error, result);
    twiml = new twilio.TwimlResponse()
    if error
      twiml.message error.message
    else
      twiml.message result.response.plain
    res.send twiml
    return

  return
