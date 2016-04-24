'use strict';
const _ = require('lodash');

// Configuration
const pageSize = 5;


const torrentToMessage = (i, torrent) => {
  var downloadSizeInMB, stats;
  downloadSizeInMB = torrent.size / 1000 / 1000;
  stats = (torrent.verified ? "Verified" : "") + (torrent.verified && (!isNaN(downloadSizeInMB) || (torrent.seeders && torrent.leechers)) ? " and " : "") + (!isNaN(downloadSizeInMB) ? (Math.round(downloadSizeInMB * 100) / 100) + " MB with " : "") + (torrent.seeders && torrent.leechers ? (torrent.seeders + " seeders and ") + (torrent.leechers + " leechers") : "");
  return (i + 1) + ". " + torrent.title + " (" + stats + ")";
};

module.exports = (sessionId, context, cb) => {
  // console.log('torrents',torrents.length,torrents);
  const offset = parseInt(context.torrents_index) || 1;
  const torrents = _.slice(context.torrents, offset, offset+pageSize)
  if (torrents) {
    let torrentsList = _.map(torrents, (torrent,i) => {
      let idx = (i+offset)
      // console.log(offset, i, idx);
      // return (idx+". "+torrent.title+'\n');
      return torrentToMessage(idx,torrent);
    });
    let isPlural = torrents.length > 1;
    context.torrents_message = `There ${isPlural?'are':'is'} ${torrents.length} torrent${isPlural?'s':''}:\n${torrentsList.join('\n')}`;
  } else {
    context.torrents_message = 'No torrents found.';
  }
  return cb(context);
};