var Transmission = require('transmission');
var config = require('../config.json');

module.exports = {
  transmission: null,

  setup: function(app) {
    // Setup
    console.log('Setup Transmission');
    console.log(config.transmission);
    this.transmission = new Transmission(config.transmission);

  },

  find: function(params, callback) {
    this.transmission.active(function (err, result) {
      return callback(err, result);
    });
  },

  get: function(id, params, callback) {
    this.transmission.get(id, function(err, result) {
        if (err) {
            return callback(err, result);
        }
        console.log('bt.get returned ' + result.torrents.length + ' torrents');
        return callback(result.torrents);
    });
  },

  create: function(data, params, callback) {
    console.log('create', data, params);
    var options = {};
    this.transmission.addUrl(data.url, options, function(err, result) {
        return callback(err, result);
    });
  },

  // update: function(id, data, params, callback) {},

  // patch: function(id, data, params, callback) {},

  remove: function(id, params, callback) {
    this.transmission.remove(id, function(err) {
        if (err) {
            return callback(err, null);
        }
        console.log('torrent was removed');
        return callback(null, true);
    });
  }

};
