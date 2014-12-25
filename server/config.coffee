# Read config.json file and strip comments from JSON
stripJsonComments = require("strip-json-comments")
fs = require("fs")
path = require("path")
json = fs.readFileSync(path.resolve(__dirname, "../config.json"), "utf8")
module.exports = JSON.parse(stripJsonComments(json))