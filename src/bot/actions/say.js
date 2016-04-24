'use strict';

module.exports = (sessionId, context, message, cb) => {
  console.log(message);
  cb();
};