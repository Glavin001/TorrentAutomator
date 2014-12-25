SearchForTorrents = require "./searchForTorrents"
DownloadTorrent = require "./downloadTorrent"
ShowDownloads = require "./showDownloads"
DownloadSeason = require "./downloadSeason"

module.exports = [
    # Do NOT include the Help command here.
    # It will be included in the Conversation code up a level 
    new SearchForTorrents()
    new DownloadTorrent()
    new ShowDownloads()
    new DownloadSeason()
  ]
