assert = require "assert"
Bot = require "../server/bot/"
SearchForTorrentCommand = require "../server/bot/commands/searchForTorrents"
DownloadSelectedTorrentCommand = \
  require "../server/bot/commands/downloadSelectedTorrent"
ShowDownloadsCommand = require "../server/bot/commands/showDownloads"
HelpCommand = require "../server/bot/commands/help"
DownloadSeasonCommand = require "../server/bot/commands/downloadSeason"
ShowMoreCommand = require "../server/bot/commands/showMore"
DownloadTorrentURLCommand = require "../server/bot/commands/downloadTorrentURL"

describe "Commands", ->
    convo = Bot.getConversation "tester"
    describe "HelpCommand", ->
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
        it "should trim space and return HelpCommand", ->
          convo.getCommands { message: "   Help.   " }, {}, (commands) ->
            assert.equal 1, commands.length
            command = commands[0]
            assert.equal true, command instanceof HelpCommand
    describe "SearchForTorrentCommand", ->
        it "should be SearchForTorrentCommand", () ->
          convo.getCommands { message: "Search for this is a test" }, {}, (commands) ->
            assert.equal 1, commands.length
            command = commands[0]
            assert.equal true, command instanceof SearchForTorrentCommand
    describe "DownloadSelectedTorrentCommand", ->
        it "should be DownloadSelectedTorrentCommand.", () ->
          convo.getCommands { message: "Download 1." }, { foundTorrents:[] }, (commands) ->
            assert.equal 1, commands.length
            command = commands[0]
            assert.equal true, command instanceof DownloadSelectedTorrentCommand
        it "should allow multiple selections and return DownloadSelectedTorrentCommand.", () ->
          convo.getCommands { message: "Download 1,2,  3, 4." }, { foundTorrents:[] }, (commands) ->
            assert.equal 1, commands.length
            command = commands[0]
            assert.equal true, command instanceof DownloadSelectedTorrentCommand
        it "should trim space and return DownloadSelectedTorrentCommand", ->
          convo.getCommands { message: "   Download 1.   " }, { foundTorrents:[] }, (commands) ->
            assert.equal 1, commands.length
            command = commands[0]
            assert.equal true, command instanceof DownloadSelectedTorrentCommand
    describe "ShowDownloadsCommand", ->
        it "should be ShowDownloadsCommand", () ->
          convo.getCommands { message: "Show downloads." }, {}, (commands) ->
            assert.equal 1, commands.length
            command = commands[0]
            assert.equal true, command instanceof ShowDownloadsCommand
          convo.getCommands { message: "List downloads." }, {}, (commands) ->
            assert.equal 1, commands.length
            command = commands[0]
            assert.equal true, command instanceof ShowDownloadsCommand
    describe "DownloadSeasonCommand", ->
        it "should be DownloadSeasonCommand", () ->
          convo.getCommands { message: "Download season 1 of Breaking Bad" }, {}, (commands) ->
            assert.equal 1, commands.length
            command = commands[0]
            assert.equal true, command instanceof DownloadSeasonCommand
    describe "ShowMoreCommand", ->
        it "should be ShowMoreCommand", () ->
          convo.getCommands { message: "Show more"}, {}, (commands) ->
            assert.equal 0, commands.length
          convo.getCommands { message: "Show more"}, { foundTorrents:[] }, (commands) ->
            assert.equal 1, commands.length
            command = commands[0]
            assert.equal true, command instanceof ShowMoreCommand
    describe "DownloadTorrentURL", ->
        it "should be DownloadTorrentURLCommand.", () ->
          convo.getCommands { message: "Download https://torcache.net/torrent/E45224537CD84471A3F7F235265284AF004F988D.torrent?title=[kat.cr]limitless.s01e14.hdtv.x264.lol.ettv" }, { foundTorrents:[] }, (commands) ->
            assert.equal 1, commands.length
            command = commands[0]
            assert.equal true, command instanceof DownloadTorrentURLCommand
        it "should trim space and return DownloadSelectedTorrentCommand", ->
          convo.getCommands { message: "   Download https://torcache.net/torrent/E45224537CD84471A3F7F235265284AF004F988D.torrent?title=[kat.cr]limitless.s01e14.hdtv.x264.lol.ettv   " }, { foundTorrents:[] }, (commands) ->
            assert.equal 1, commands.length
            command = commands[0]
            assert.equal true, command instanceof DownloadTorrentURLCommand
        it "should allow multiple Torrent URLs and return DownloadTorrentURLCommand.", () ->
          convo.getCommands { message: "Download https://torcache.net/torrent/E45224537CD84471A3F7F235265284AF004F988D.torrent?title=[kat.cr]limitless.s01e14.hdtv.x264.lol.ettv https://torcache.net/torrent/E45224537CD84471A3F7F235265284AF004F988D.torrent?title=[kat.cr]limitless.s01e14.hdtv.x264.lol.ettv " }, { foundTorrents:[] }, (commands) ->
            assert.equal 1, commands.length
            command = commands[0]
            assert.equal true, command instanceof DownloadTorrentURLCommand
