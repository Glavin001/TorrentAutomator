'use strict';
module.exports = (sessionId, context, cb) => {

  let idx = context.download_torrent_index;
  idx = idx.map((i) => parseInt(i) - 1);
  let torrents = idx.map((i) => {
    return context.torrents[i];
  });
  context.download_message = `Downloading torrent ${torrents.map((torrent)=>torrent.title)}.`;
  delete context.download_torrent_index;

  return cb(context);
};