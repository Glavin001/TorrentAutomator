'use strict';
const conversation = require('./conversation');
const sms = require('./sms');
const authentication = require('./authentication');
const user = require('./user');

module.exports = function() {
  const app = this;

  app.configure(authentication);
  app.configure(user);
  app.configure(sms);
  app.configure(conversation);
};
