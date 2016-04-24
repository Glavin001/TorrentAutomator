'use strict';
module.exports = (sessionId, context, cb) => {
  console.log('torrents_index', context.torrents_index, context.page_direction);
  if (context.page_direction) {
    switch (context.page_direction) {
      case 'next':
        context.torrents_index += pageSize;
        break;
      case 'previous':
        context.torrents_index -= pageSize;
        break;
      default:
    }
  }
  delete context.page_direction;
  console.log('torrents_index', context.torrents_index);
  if (context.torrents_index < 1) {
    context.torrents_index = 1;
  }
  return actions['list-torrents'](sessionId, context, cb);
};