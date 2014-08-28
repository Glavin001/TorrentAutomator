Conversation = require("./conversation")
module.exports =
  allConversations: {}
  generateResponse: (input, callback) ->
    self = this
    conversation = self.getConversation(input.from)
    conversation.respond input, callback

  getConversation: (from) ->
    self = this
    conversation = self.allConversations[from]
    if conversation
      conversation
    else
      conversation = new Conversation(from)
      self.allConversations[from] = conversation
      conversation
