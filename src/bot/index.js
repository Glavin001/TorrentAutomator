'use strict';

// When not cloning the `node-wit` repo, replace the `require` like so:
// const Wit = require('node-wit').Wit;
const Wit = require('node-wit').Wit;
const Botkit = require('botkit');
// Actions
const actions = require('./actions');
const sessions = require('./sessions');

const tokens = (() => {
  if (process.argv.length < 3) {
    console.log('usage: node examples/template.js <wit-token> <slack-token>');
    process.exit(1);
  }
  return {
    wit: process.argv[2],
    slack: process.argv[3]
  };
})();

const client = new Wit(tokens.wit, actions);
if (tokens.slack) {

  var controller = Botkit.slackbot({
    debug: false
      //include "log: false" to disable logging
      //or a "logLevel" integer from 0 to 7 to adjust logging verbosity
  });

  // connect the bot to a stream of messages
  controller.spawn({
    token: tokens.slack
  }).startRTM();

  // give the bot something to listen for.
  controller.hears('.*', ['direct_message', 'direct_mention', 'mention'], function(bot, message) {
    // console.log(message);
    let sessionId = `${message.team}-${message.channel}`;

    let session = sessions.getSession(sessionId);
    let context = session.context;
    session.bot = bot;
    session.message = message;

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
          session.context = context;
        }
      }
    );

  });
} else {
  client.interactive();
}