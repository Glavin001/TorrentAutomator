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
const actions = _.fromPairs(_.map(actionNames, (action)=>[action, require(`./${action}`)]));
module.exports = actions;