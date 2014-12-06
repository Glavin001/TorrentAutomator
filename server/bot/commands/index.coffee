SearchForTorrents = require "./searchForTorrents"
DownloadTorrent = require "./downloadTorrent"
ShowDownloads = require "./showDownloads"
DownloadSeason = require "./downloadSeason"

module.exports = [
    new SearchForTorrents()
    new DownloadTorrent()
    new ShowDownloads()
    new DownloadSeason()
  ]
