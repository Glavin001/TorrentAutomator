$(document).ready(function() {
    console.log('Ready!');

    // Elements
    var $searchTorrentsBtn = $('.search-torrents-btn');
    var $searchInput = $('#torrent-search-query');
    var $torrentsListOutput = $('.torrents-list-output');

    // Templates
    var torrentsSource = $("#torrents-template").html();
    var torrentsTemplate = Handlebars.compile(torrentsSource);

    var downloadTorrent = function(torrent) {
        $.post("/api/transmission", {
            url: torrent.torrentUrl
        }).done(function(data) {
            console.log(data);
        });
    };

    var showTorrents = function(torrents) {
        var html = torrentsTemplate({
            "torrents": torrents
        });
        $torrentsListOutput.html(html);
    };

    var searchForTorrents = function(event) {
        // Prevent the form from reloading the page
        event.preventDefault();

        // Get query
        var query = $searchInput.val();
        console.log(query);

        // Send request to retrieve Torrents given query
        $.get("/api/torrents", {
            'query': query
        }).done(function(data) {
            console.log(data);
            showTorrents(data);
        });
    };

    // Handle events
    $searchTorrentsBtn.click(searchForTorrents);
    $torrentsListOutput.delegate( ".download-torrent-btn", "click", function() {
      var $el = $(event.target);
      var torrent = JSON.parse($el.attr('data-torrent'));
      console.log(torrent);
      downloadTorrent(torrent);
    });

});
