#!/usr/bin/env coffee

feathers = require("feathers")
bodyParser = require("body-parser")
path = require("path")
twilio = require("twilio")
config = require("./config")

# Public Directory
publicPath = path.resolve(__dirname, "../app")

# Services
transmissionService = require("./services/transmissionService")
providerService = require("./services/providerService")
twilioService = require("./services/twilioService")
botService = require("./services/botService")

# Create App Server
app = feathers()
# Configure
app.configure(feathers.rest())
.configure(feathers.socketio())
# Enable parsing for POST, PUT and PATCH requests
# in JSON and URL encoded forms
.use(bodyParser.json())
.use(bodyParser.urlencoded(extended: true))
# Services
.use("/api/transmission", transmissionService)
.use("/api/torrents", providerService)
.use("/api/bot", botService)
# Public static content
.use(feathers.static(publicPath))
.post("/api/sms", twilio.webhook(config.twilio.authToken, {
  validate: false
}), twilioService.receive)
# Start server listening
.listen config.server.port, ->
  console.log "Listening on http://localhost:" + config.server.port
