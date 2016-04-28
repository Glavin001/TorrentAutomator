'use strict';
const _ = require('lodash');
const actionNames = [
  'say',
  'merge',
  'error',
  'find-movie',
  'find-show',
  'list-torrents',
  'download-torrents',
  'paginate-torrents'
];
module.exports = _.fromPairs(_.map(actionNames, (action) => {
  return [action, require(`./${action}`)];
}));