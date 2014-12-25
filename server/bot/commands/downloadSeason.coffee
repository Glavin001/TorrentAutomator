async = require "async"
Command = require "./base"
TorrentClient = require "../../clients/"
EZTVProvider = require "../../providers/eztv"

# Setup
module.exports = class DownloadSeasonCommand extends Command
  constructor: ->
    super
    @client = new TorrentClient()
    @torrentProvider = new EZTVProvider()
    return @
  help: "Download season <season #> of <tv show>"
  filter: new RegExp("^[dD]ownload [sS]eason ([0-9]+) of (.*)$")
  run: (input, context, callback) ->
    self = this

    # console.log(input, context);
    query = input.message
    queryParts = (query.match(self.filter))

    seasonNum = parseInt(queryParts[1])
    showName = queryParts[2]
    # console.log(queryParts)

    if isNaN(seasonNum)

      # User error
      return callback(null,
        response:
          plain: "Sorry, \"" + query + "\" is not a season number."
      )

    q = "#{showName} S#{seasonNum}"
    @torrentProvider.search q, {}, (err, torrents) =>
        # console.log(err, torrents)
        return callback(err, null) if err

        # Cache all of the episodes
        cache = {}
        # Iterate thru episodes in season
        showName = torrents[0].meta.show
        for torrent in torrents
            # console.log(torrent)
            show = torrent.meta.show
            episodeNumber = torrent.meta.episodeNumber
            cache[show] ?= {}
            if not cache[show][episodeNumber]?
                cache[show][episodeNumber] = torrent
            else
                # Episode already set
                c = cache[show][episodeNumber]
                # Check if there is a repack or proper
                if torrent.meta.repack || torrent.meta.proper
                    cache[show][episodeNumber] = torrent
                #if (not c.meta.repack and torrent.meta.repack) \
                #    || (not c.meta.proper and torrent.meta.proper)
                #        cache[show][episodeNumber] = torrent
                
        # console.log(JSON.stringify(cache[showName], undefined, 4))
        episodes = cache[showName]
        # es = Object.keys(episodes).sort()
        # console.log(es)
        # first = es[0]
        # last = es[es.length - 1]
        # console.log(first, last)

        # Create tasks list
        tasks = []
        downloads = {
            successful: []
            errored: []
        }
        # Iterate through allProviders
        for episodeNum, episode of episodes
            ((torrent, episodeNum) => (
                # Add task
                tasks.push (cb) =>
                    # Modify to fit Transmission Service API
                    torrent.url = torrent.torrentUrl
                    @client.addTorrent torrent, (error, result) ->
                        # console.log(error, result);
                        if (error)
                            downloads.errored.push(episodeNum)
                        else
                            downloads.successful.push(episodeNum)
                        return cb(null, episodeNum)   
            ))(episode, episodeNum)

        # Run all tasks in parallel
        # console.log(tasks)
        async.series tasks, (err, allResults) =>
            # console.log "done", err, allResults
            return callback err, null if err

            results = [].concat.apply([], allResults)
            message = "Downloaded #{downloads.successful.length} episodes " + \
            "(#{downloads.successful.join(', ')})" + \
            " of Season #{seasonNum} of #{showName}." + \
            (if (downloads.errored.length > 0) then " Errors occurred on episodes #{downloads.errored.join(', ')}." else "")
            
            response = response:
                            plain: message
            return callback err, response

        #return callback(null, 'Feature coming soon.')