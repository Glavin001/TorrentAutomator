var transmissionService = require('../../services/transmissionService');
var prettyMs = require('pretty-ms');
// Setup
transmissionService.setup();

module.exports = {
  'regex': new RegExp('^(?=([sS]how)|([lL]ist)( (me|my))?( currently)? download(ing|s)).*$'),
  'run': function(input, context, callback) {
    var self = this;
    return transmissionService.find({}, function(error, result) {
      if (error) {
        return callback(error, null);
      } else {
        // var message = JSON.stringify(result, undefined, 2);
        // console.log(result);
        var torrents = result.torrents;
        var message = torrents.length+' active Torrent(s):\n';
        // List the available Torrents
        var len = torrents.length;
        for (var i=0; i<len; i++)
        {
          var torrent = torrents[i];
          // console.log(torrent);
          var stats;
          if (torrent.eta != -1)
          {
            var eta = prettyMs(torrent.eta * 1000) + ' remaining';
            var perc = (Math.round( (torrent.percentDone * 100) * 10 ) / 10 ) + '% downloaded';
            stats = perc + ' with ' + eta;
          } else {
            var stats = 'Completed Downloading';
          }
          message += (i+1)+'. '+ torrent.name + ' (' +  stats + ') \n';
        }
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