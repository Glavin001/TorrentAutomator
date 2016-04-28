'use strict';
const Wit = require('node-wit').Wit;
const Botkit = require('botkit');

module.exports = function() {
  const app = this;
  const conversations = app.service('conversations');
  // Actions
  const actions = require('./actions');
  const client = new Wit(app.get('wit').token, actions);

  let controller = Botkit.slackbot({
    debug: false
      //include "log: false" to disable logging
      //or a "logLevel" integer from 0 to 7 to adjust logging verbosity
  });

  // connect the bot to a stream of messages
  let bot1 = controller.spawn({
    token: app.get('slack').token
  });
  bot1.startRTM();

  function findOrCreateConversation(convoId) {
    // console.log('convoId', convoId);
    return conversations.find({
        query: {
          _id: convoId
        }
      })
      .then((result) => {
        // console.log('result', result);
        if (result.total > 0) {
          return Promise.resolve(result.data[0]);
        } else {
          return conversations.create({
            _id: convoId,
            context: {}
          });
        }
      });
  }

  // give the bot something to listen for.
  controller.hears('.*', ['direct_message', 'direct_mention', 'mention'], function(bot, message) {
    // console.log(message);
    let sessionId = `${message.team}-${message.channel}`;

    findOrCreateConversation(sessionId)
      .then((convo) => {
        // console.log('convo1', convo);
        return conversations.patch(sessionId, {
          // id: sessionId,
          message: message,
          // context: context
        });
      })
      .then((convo) => {
        // console.log('convo2', convo);

        let context = convo.context;
        let msg = message.text;

        // Let's forward the message to the Wit.ai Bot Engine
        // This will run all actions until our bot has nothing left to do
        client.runActions(
          sessionId, // the user's current session
          msg, // the user's message
          context, // the user's current session state
          (error, context) => {
            if (error) {
              console.error('Oops! Got an error from Wit:', error);
            } else {
              // Our bot did everything it has to do.
              // Now it's waiting for further messages to proceed.
              // console.log('Waiting for futher messages.');

              // Based on the session state, you might want to reset the session.
              // This depends heavily on the business logic of your bot.
              // Example:
              // if (context['done']) {
              //   delete sessions[sessionId];
              // }


              // Updating the user's current session state
              conversations.update(sessionId, {
                _id: sessionId,
                message: message,
                context: context
              });
              // conversations.patch(sessionId, {
              //   // message: message,
              //   context: context
              // });

            }
          }
        );

      })
      .catch((error) => {
        console.log('error', error);
        bot.reply(message, error.message);

      });

  });

};