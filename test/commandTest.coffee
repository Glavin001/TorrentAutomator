assert = require "assert"
Bot = require "../server/bot/"
SearchForTorrentCommand = require "../server/bot/commands/searchForTorrents"
DownloadTorrentCommand = require "../server/bot/commands/downloadTorrent"
ShowDownloadsCommand = require "../server/bot/commands/showDownloads"

describe "Bot", () ->
  describe "Commands", ->
    convo = Bot.getConversation "tester"
    it "should be SearchForTorrentCommand", () ->
      convo.getCommands { message: "Search for this is a test" }, {}, (commands) ->
        assert.equal 1, commands.length
        command = commands[0]
        assert.equal true, command instanceof SearchForTorrentCommand
    it "should be DownloadTorrentCommand.", () ->
      convo.getCommands { message: "Download 1." }, { foundTorrents:[]}, (commands) ->
        assert.equal 1, commands.length
        command = commands[0]
        assert.equal true, command instanceof DownloadTorrentCommand
    it "should be ShowDownloadsCommand", () ->
      convo.getCommands { message: "Show downloads." }, {}, (commands) ->
        assert.equal 1, commands.length
        command = commands[0]
        assert.equal true, command instanceof ShowDownloadsCommand
