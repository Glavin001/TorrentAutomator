async = undefined
async = require("async")
module.exports =
  allCommands: [
    require("./searchForTorrents")
    require("./downloadTorrent")
    require("./showDownloads")
  ]
  processInput: (input, context, callback) ->
    @getCommands input, context, (commands) ->
      command = undefined
      command = commands[0]
      unless not command
        command.run input, context, callback
      else
        callback new Error("Could not find an applicable command."), null


  getCommands: (input, context, callback) ->
    commands = undefined
    message = undefined
    message = input.message
    commands = @allCommands
    async.filter commands, ((command, callback) ->
      checkFun = undefined
      regex = undefined
      checkFun = command.check
      regex = command.regex
      return callback(false)  if regex and not regex.test(message)
      if checkFun
        kickassService = require("../../services/kickassService")

        # Setup
        kickassService.setup()
        module.exports =
          maxResults: 5
          regex: new RegExp("^[sS]earch for (.*)")
          run: (input, context, callback) ->
            self = this

            # console.log(input);
            query = input.message
            query = query.match(self.regex)[1]

            # console.log(query);
            kickassService.find
              query:
                query: query
            , (err, results) ->

              # console.log(results);
              message = "Found " + results.length + " Torrent(s). Here are the top 5:\n"

              # List the available Torrents
              len = Math.min(self.maxResults, results.length)
              i = 0

              while i < len
                torrent = results[i]
                downloadSizeInMB = torrent.size / 1000 / 1000
                stats = ((if torrent.verified then "Verified and " else "")) + Math.round(downloadSizeInMB * 100) / 100 + " MB with " + torrent.seeds + " seed and " + torrent.leechs + " leech"
                message += (i + 1) + ". " + torrent.title + " (" + stats + ") \n"
                i++

              # Create response
              response = response:
                plain: message


              # Save Torrents to context
              context.foundTorrents = results

              # return
              callback err, response

            return

        checkFun input, context, callback
      else
        callback true
    ), (results) ->
      callback results

    return
