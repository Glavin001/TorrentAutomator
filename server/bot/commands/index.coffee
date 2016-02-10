SearchForTorrents = require "./searchForTorrents"
DownloadSelectedTorrent = require "./downloadSelectedTorrent"
ShowDownloads = require "./showDownloads"
DownloadSeason = require "./downloadSeason"
ShowMore = require "./showMore"
DownloadTorrentURL = require "./downloadTorrentURL"

module.exports = [
  # Do NOT include the Help command here.
  # It will be included in the Conversation code up a level
  new SearchForTorrents()
  new DownloadSelectedTorrent()
  new ShowDownloads()
  new DownloadSeason()
  new ShowMore()
  new DownloadTorrentURL()
]
