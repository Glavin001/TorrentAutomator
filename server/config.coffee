# Read config.json file and strip comments from JSON
stripJsonComments = require("strip-json-comments")
fs = require("fs")
path = require("path")
json = fs.readFileSync(path.resolve(__dirname, "../config.json"), "utf8")
config = JSON.parse(stripJsonComments(json))
# Environment Variables
config.twilio ?= {}
config.twilio.phone ?= process.env.TWILIO_PHONE
config.twilio.accountSid ?= process.env.TWILIO_ACCOUNT_SID
config.twilio.authToken ?= process.env.TWILIO_AUTH_TOKEN
# Save config
module.exports = config
