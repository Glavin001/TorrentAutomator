var feathers = require('feathers');
var bodyParser = require('body-parser');
var path = require('path');
var twilio = require('twilio');
var config = require('../config.json');
// Public Directory
var publicPath = path.resolve(__dirname, '../app');
// Services
var transmissionService = require('./services/transmissionService.js');
var kickassService = require('./services/kickassService.js');
var twilioService = require('./services/twilioService.js');
var botService = require('./services/botService.js');

// Create App Server
var app = feathers();
// Configure
app.configure(feathers.rest())
.configure(feathers.socketio())
// Enable parsing for POST, PUT and PATCH requests
// in JSON and URL encoded forms
.use(bodyParser.json())
.use(bodyParser.urlencoded({ extended: true }))
// Services
.use('/api/transmission', transmissionService)
.use('/api/kickass', kickassService)
.use('/api/bot', botService)
// Public static content
.use(feathers.static(publicPath))
//
.post('/api/sms', twilio.webhook(config.twilio.authToken), twilioService.receive)
// Start server listening
.listen(config.server.port, function() {
    console.log("Listening on http://localhost:" + config.server.port);
});
