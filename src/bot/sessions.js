'use strict';

var sessions = {};
module.exports = {
  getSession(sessionId) {
    return sessions[sessionId] = sessions[sessionId] || {
      sessionId: sessionId,
      context: {}
    };
  }
};