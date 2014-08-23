var async = require('async');

module.exports = {
  allCommands: [
    require('./searchForTorrents'),
    require('./downloadTorrent')
  ],
  processInput: function(input, context, callback) {
    return this.getCommands(input, context, function(commands) {
      console.log('commands', commands);
      // Get first available command
      var command = commands[0];
      // Check if command found
      if (!!command) {
        // Execute command
        return command.run(input, context, callback);
      } else {
        // Command not found
        return callback(new Error("Could not find an applicable command."), null);
      }
    });
  },
  getCommands: function(input, context, callback) {
    var message = input.message;
    var commands = this.allCommands;
    async.filter(commands, function(command, callback) {
      // Check if command is applicable
      var checkFun = command.check;
      var regex = command.regex;
      // Check for Regex test
      // console.log(typeof message, message);
      if (regex && !regex.test(message)) {
        // Failed
        return callback(false);
      }
      // Check function
      if (checkFun) {
        return checkFun(input, context, callback);
      } else {
        return callback(true);
      }
    }, function(results){
      // results now equals an array of the existing files
      // console.log(results);
      return callback(results);
    });
  }
};