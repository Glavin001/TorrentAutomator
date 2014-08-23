var commands = require('./commands');

module.exports = function(from) {
  var self = this;
  self.history = [];
  self.context = {};
  self.respond = function(input, callback) {
    commands.processInput(input, self.context, callback);
  };
};