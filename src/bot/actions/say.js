'use strict';

const sessions = require('../sessions');

module.exports = (sessionId, context, message, cb) => {
  // console.log(message);
  let session = sessions.getSession(sessionId);
  // console.log(sessionId, session);
  if (session.bot) {
    let bot = session.bot;
    bot.reply(session.message, message);
  }
  cb();
};