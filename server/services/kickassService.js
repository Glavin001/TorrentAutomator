var Kickass = require('node-kickass-json');

module.exports = {
    kickass: null,

    setup: function(app) {
        // Setup
        console.log('Setup Kickass');
        this.kickass = new Kickass();
    },

    find: function(params, callback) {
        console.log(params);
        var query = params.query;
        console.log('query: ', query);
        this.kickass.setQuery(query.query) // Set search Query parameter
        .setSort({
            field: query.field || 'seeders',
            sorder: query.sorder || 'desc'
        }).run(function(error, data) {
            return callback(error, data);
        });
    },

    // get: function(id, params, callback) {
    //   this.transmission.get(id, function(err, result) {
    //       if (err) {
    //           return callback(err, result);
    //       }
    //       console.log('bt.get returned ' + result.torrents.length + ' torrents');
    //       return callback(result.torrents);
    //   });
    // }

};
