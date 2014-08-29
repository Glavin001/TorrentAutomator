SearchForTorrents = require "./searchForTorrents"
DownloadTorrent = require "./downloadTorrent"
ShowDownloads = require "./showDownloads"

module.exports = [
    new SearchForTorrents()
    new DownloadTorrent()
    new ShowDownloads()
  ]
