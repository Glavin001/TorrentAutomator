#!/usr/bin/env coffee

feathers = require("feathers")
bodyParser = require("body-parser")
path = require("path")
twilio = require("twilio")
config = require("../config.json")

# Public Directory
publicPath = path.resolve(__dirname, "../app")

# Services
transmissionService = require("./services/transmissionService")
kickassService = require("./services/kickassService")
twilioService = require("./services/twilioService")
botService = require("./services/botService")

# Create App Server
app = feathers()

# Configure

# Enable parsing for POST, PUT and PATCH requests
# in JSON and URL encoded forms

# Services

# Public static content

#

# Start server listening
app.configure(feathers.rest()).configure(feathers.socketio()).use(bodyParser.json()).use(bodyParser.urlencoded(extended: true)).use("/api/transmission", transmissionService).use("/api/kickass", kickassService).use("/api/bot", botService).use(feathers.static(publicPath)).post("/api/sms", twilio.webhook(config.twilio.authToken), twilioService.receive).listen config.server.port, ->
  console.log "Listening on http://localhost:" + config.server.port
  return
