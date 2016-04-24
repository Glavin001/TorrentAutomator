'use strict';
const FindTorrent = require('machinepack-findtorrent');
const ListTorrents = require('./list-torrents');

module.exports = (sessionId, context, cb) => {

  FindTorrent.findMovie({
    query: context.movie_title
  }).exec({
    error(err) {
      console.log(err)
      context.torrents = [];
      return ListTorrents(sessionId, context, cb);
    },
    success(torrents) {
      console.log('this',this);
      context.torrents = torrents;
      // delete context.movie_title;
      context.torrents_index = 1;
      return ListTorrents(sessionId, context, cb);
    }
  });

};