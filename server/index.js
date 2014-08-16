var feathers = require('feathers');
var bodyParser = require('body-parser');
var path = require('path');
var config = require('../config.json');
// Public Directory
var publicPath = path.resolve(__dirname, '../app');
// Services
var transmissionService = require('./transmissionService.js');
var kickassService = require('./kickassService.js');

// Create App Server
var app = feathers();
// Configure
app.configure(feathers.rest())
    .configure(feathers.socketio())
    .use(bodyParser())
    // Services
    .use('/api/transmission', transmissionService)
    .use('/api/kickass', kickassService)
    // Public static content
    .use(feathers.static(publicPath))
    // Start server listening
    .listen(config.server.port, function() {
      console.log("Listening on http://localhost:"+config.server.port);
    });
