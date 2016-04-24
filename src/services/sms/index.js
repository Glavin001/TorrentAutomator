'use strict';

const hooks = require('./hooks');

class Service {
  constructor(options) {
    this.options = options || {};
  }

  create(data, params) {
    if(Array.isArray(data)) {
      return Promise.all(data.map(current => this.create(current)));
    }

    return Promise.resolve(data);

    let twiml = new twilio.TwimlResponse();
    res.send(twiml);
    let from = req.body.From;
    let message = req.body.Body;
    return bot.generateResponse({
      conversation: from,
      message: message,
      meta: req.body
    }, function(error, result) {
      var body;
      if (error) {
        body = "An error occurred: " + error.message;
      } else {
        body = result.response.plain;
      }
      return client.sendMessage({
        to: from,
        from: TWILIO_PHONE,
        body: body
      }, function(err, responseData) {});
    });

  }

}

module.exports = function(){
  const app = this;

  const feathersTwilio = require('feathers-twilio');
  app.use('/twilio/sms', feathersTwilio.sms({
    accountSid: app.get('twilio').accountSid,
    authToken: app.get('twilio').authToken // ex. your.domain.com
  }));

  // Initialize our service with any options it requires
  let service = new Service();
  app.use('/sms', service);

  // Get our initialize service to that we can bind hooks
  const smsService = app.service('/sms');

  // Set up our before hooks
  smsService.before(hooks.before);

  // Set up our after hooks
  smsService.after(hooks.after);
};

module.exports.Service = Service;
