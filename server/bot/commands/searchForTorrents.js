var kickassService = require('../../services/kickassService');
// Setup
kickassService.setup();

module.exports = {
  'maxResults': 5,
  'regex': new RegExp('^[sS]earch for (.*)'),
  'run': function(input, context, callback) {
    var self = this;
    // console.log(input);
    var query = input.message;
    query = query.match(self.regex)[1];
    // console.log(query);
    kickassService.find({ query: { query: query } }, function(err, results) {
        // console.log(results);
        var message = 'Found '+results.length+' Torrent(s). Here are the top 5:\n';
        // List the available Torrents
        var len = Math.min(self.maxResults, results.length);
        for (var i=0; i<len; i++)
        {
          var torrent = results[i];
          var downloadSizeInMB = torrent.size / 1000 / 1000;
          var stats = (torrent.verified?'Verified and ':'') + Math.round(downloadSizeInMB * 100)/100 + ' MB with '+torrent.seeds+' seed and '+torrent.leechs+' leech';
          message += (i+1)+'. '+ torrent.title + ' ('+stats+') \n';
        }
        // Create response
        var response = {
          'response': {
            'plain': message
          }
        };
        // Save Torrents to context
        context.foundTorrents = results;
        // return
        return callback(err, response);
      });
  }
};