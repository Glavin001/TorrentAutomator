var bot = require('../bot');

module.exports = {

  create: function(data, params, callback) {
    // console.log('create', data, params);
    var from = data.from;
    var message = data.message;
    var meta = data;
    bot.generateResponse({
        'conversation': from,
        'message': message,
        'meta': data
    }, function(error, result) {
        return callback(error, result);
    });
  }

};
