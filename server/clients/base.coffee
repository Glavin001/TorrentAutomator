# Base Torrent Client class
module.exports = class TorrentClient
  addTorrent: (url, cb) =>
    throw new Error "Subclasses must implement `addTorrent` function."
  list: (cb) =>
    throw new Error "Subclasses must implement `list` function."
