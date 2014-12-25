assert = require "assert"
Bot = require "../server/bot/"
SearchForTorrentCommand = require "../server/bot/commands/searchForTorrents"
DownloadTorrentCommand = require "../server/bot/commands/downloadTorrent"
ShowDownloadsCommand = require "../server/bot/commands/showDownloads"
HelpCommand = require "../server/bot/commands/help"
DownloadSeasonCommand = require "../server/bot/commands/downloadSeason"

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
      convo.getCommands { message: "List downloads." }, {}, (commands) ->
        assert.equal 1, commands.length
        command = commands[0]
        assert.equal true, command instanceof ShowDownloadsCommand
    it "should be HelpCommand", () ->
      convo.getCommands { message: "Show commands." }, {}, (commands) ->
        assert.equal 1, commands.length
        command = commands[0]
        assert.equal true, command instanceof HelpCommand
      convo.getCommands { message: "List commands." }, {}, (commands) ->
        assert.equal 1, commands.length
        command = commands[0]
        assert.equal true, command instanceof HelpCommand
      convo.getCommands { message: "Help." }, {}, (commands) ->
        assert.equal 1, commands.length
        command = commands[0]
        assert.equal true, command instanceof HelpCommand
    it "should be DownloadSeasonCommand", () ->
      convo.getCommands { message: "Download season 1 of Breaking Bad" }, {}, (commands) ->
        assert.equal 1, commands.length
        command = commands[0]
        assert.equal true, command instanceof DownloadSeasonCommand
