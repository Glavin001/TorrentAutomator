'use strict';
const Botkit = require('botkit');

module.exports = (sessionId, context, message, cb) => {
  // console.log(message);
  const app = require('../../app');
  const conversations = app.service('conversations');

  conversations.get(sessionId)
    .then((convo) => {
      // console.log('convo3', convo);

      let controller = Botkit.slackbot({
        debug: false
          //include "log: false" to disable logging
          //or a "logLevel" integer from 0 to 7 to adjust logging verbosity
      });

      let bot = controller.spawn({
        token: app.get('slack').token
      });
      // console.log('bot', bot);
      bot.startRTM(function(err) {
        bot.reply(convo.message, message);
        // console.log('reply');
        cb();
      });

    }).catch((error) => {
      cb(error);
    });

};