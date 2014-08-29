
module.exports = class Torrent
  constructor: ({
    @title,
    @torrentUrl,
    @link,
    @seeders,
    @leechers,
    @size,
    @verified,
    @dateCreated,
    @hash,
    @meta
    }) ->
