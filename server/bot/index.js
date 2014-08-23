var Conversation = require('./conversation');

module.exports = {
  allConversations: {},

  generateResponse: function(input, callback) {
    var self = this;
    var conversation = self.getConversation(input.from);
    return conversation.respond(input, callback);
  },

  getConversation: function(from) {
    var self = this;
    var conversation = self.allConversations[from];
    if (conversation) {
      return conversation;
    } else {
      conversation = new Conversation(from);
      self.allConversations[from] = conversation;
      return conversation;
    }
  }

};
