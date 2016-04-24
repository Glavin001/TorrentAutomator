'use strict';
const FindTorrent = require('machinepack-findtorrent');
const ListTorrents = require('./list-torrents');

module.exports = (sessionId, context, cb) => {
  // console.log('this',this,this.actions, this['list-torrents']);
  FindTorrent.findEpisode({
    query: context.show_title
  }).exec({
    error(err) {
      console.log(err)
      context.torrents = [];
      return ListTorrents(sessionId, context, cb);
    },
    success(torrents) {
      // console.log('this',this.actions, this['list-torrents']);
      context.torrents = torrents;
      // delete context.show_title;
      // delete context.season_number;
      // delete context.episode_number;
      context.torrents_index = 1;
      // return cb(context);
      return ListTorrents(sessionId, context, cb);
    }
  });
};