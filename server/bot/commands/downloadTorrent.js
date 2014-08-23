var transmissionService = require('../../services/transmissionService');
// Setup
transmissionService.setup();

module.exports = {
  'regex': new RegExp('^[dD]ownload ([0-9]*).*$'),
  'check': function(input, context, callback) {
    // console.log(context, context.foundTorrents);
    return callback(!!context.foundTorrents);
  },
  'run': function(input, context, callback) {
    var self = this;
    // console.log(input, context);
    var query = input.message;
    selection = parseInt(query.match(self.regex)[1]);
    // console.log(selection);
    if (isNaN(selection)) {
      // User error
      return callback(null, {
        'response': {
          'plain': 'Sorry, "'+query+'" is not a selection number.'
        }
      })
    }
    // Change selection from 1-based index to 0-based
    selection--;
    // Get Torrent
    var torrent = context.foundTorrents[selection];
    // Check if exists
    if (!torrent)
    {
      // User error
      var message = "No Torrent found for selection "+selection+"+. ";
      message += "Please search for a Torrent.";
      var response = {
        'response': {
          'plain': message
        }
      };
      return callback(null, response);
    }
    // Modify to fit Transmission Service API
    torrent.url = torrent.torrentLink;
    return transmissionService.create(torrent, {}, function(error, result) {
      // console.log(error, result);
      if (error) {
        return callback(error, null);
      } else {
        var message = 'Successfully started downloading '+torrent.title;
        var response = {
          'response': {
            'plain': message
          }
        };
        return callback(null, response);
      }
    });
  }
};