'use strict';

// When not cloning the `node-wit` repo, replace the `require` like so:
// const Wit = require('node-wit').Wit;
const Wit = require('node-wit').Wit;
const FindTorrent = require('machinepack-findtorrent');
const _ = require('lodash');

// Configuration
const pageSize = 5;

const token = (() => {
  if (process.argv.length !== 3) {
    console.log('usage: node examples/template.js <wit-token>');
    process.exit(1);
  }
  return process.argv[2];
})();

const firstEntityValue = (entities, entity) => {
  const val = entities && entities[entity] &&
    Array.isArray(entities[entity]) &&
    entities[entity].length > 0 &&
    entities[entity][0].value;
  if (!val) {
    return null;
  }
  return typeof val === 'object' ? val.value : val;
};


const allEntityValues = (entities, entity) => {
  const val = entities && entities[entity] &&
    Array.isArray(entities[entity]) &&
    entities[entity].map((i) => i.value);
  if (!val) {
    return null;
  }
  return val;
};

const torrentToMessage = (i, torrent) => {
  var downloadSizeInMB, stats;
  downloadSizeInMB = torrent.size / 1000 / 1000;
  stats = (torrent.verified ? "Verified" : "") + (torrent.verified && (!isNaN(downloadSizeInMB) || (torrent.seeders && torrent.leechers)) ? " and " : "") + (!isNaN(downloadSizeInMB) ? (Math.round(downloadSizeInMB * 100) / 100) + " MB with " : "") + (torrent.seeders && torrent.leechers ? (torrent.seeders + " seeders and ") + (torrent.leechers + " leechers") : "");
  return (i + 1) + ". " + torrent.title + " (" + stats + ")";
}

const actions = {
  say: (sessionId, context, message, cb) => {
    console.log(message);
    cb();
  },
  merge: (sessionId, context, entities, message, cb) => {

    // Retrieve the location entity and store it into a context field
    // console.log('merge entities', entities);

    // Single value entities
    const skeys = ['movie_title', 'show_title', 'page_direction'];
    for (let k of skeys) {
      const val = firstEntityValue(entities, k);
      if (val) {
        context[k] = val;
      }
    }

    // Multiple value entities
    const mkeys = ['download_torrent_index'];
    for (let k of mkeys) {
      const val = allEntityValues(entities, k);
      if (val) {
        context[k] = val;
      }
    }

    cb(context);
  },
  error: (sessionId, context, err) => {
    console.log(err.message);
  },
  'find-movie': (sessionId, context, cb) => {

    FindTorrent.findMovie({
      query: context.movie_title
    }).exec({
      error(err) {
        console.log(err)
        context.torrents = [];
        return actions['list-torrents'](sessionId, context, cb);
      },
      success(torrents) {
        console.log('this',this);
        context.torrents = torrents;
        // delete context.movie_title;
        context.torrents_index = 1;
        return actions['list-torrents'](sessionId, context, cb);
      }
    });

  },
  'find-show': (sessionId, context, cb) => {
    // console.log('this',this,this.actions, this['list-torrents']);
    FindTorrent.findEpisode({
      query: context.show_title
    }).exec({
      error(err) {
        console.log(err)
        context.torrents = [];
        return actions['list-torrents'](sessionId, context, cb);
      },
      success(torrents) {
        // console.log('this',this.actions, this['list-torrents']);
        context.torrents = torrents;
        // delete context.show_title;
        // delete context.season_number;
        // delete context.episode_number;
        context.torrents_index = 1;
        // return cb(context);
        return actions['list-torrents'](sessionId, context, cb);
      }
    });
  },
  'list-torrents': (sessionId, context, cb) => {
    // console.log('torrents',torrents.length,torrents);
    const offset = parseInt(context.torrents_index) || 1;
    const torrents = _.slice(context.torrents, offset, offset+pageSize)
    if (torrents) {
      let torrentsList = _.map(torrents, (torrent,i) => {
        let idx = (i+offset)
        // console.log(offset, i, idx);
        // return (idx+". "+torrent.title+'\n');
        return torrentToMessage(idx,torrent);
      });
      let isPlural = torrents.length > 1;
      context.torrents_message = `There ${isPlural?'are':'is'} ${torrents.length} torrent${isPlural?'s':''}:\n${torrentsList.join('\n')}`;
    } else {
      context.torrents_message = 'No torrents found.';
    }
    return cb(context);
  },
  'download-torrents': (sessionId, context, cb) => {

    let idx = context.download_torrent_index;
    idx = idx.map((i) => parseInt(i) - 1);
    let torrents = idx.map((i) => {
      return context.torrents[i];
    });
    context.download_message = `Downloading torrent ${torrents.map((torrent)=>torrent.title)}.`;
    delete context.download_torrent_index;

    return cb(context);
  },
  'paginate-torrents': (sessionId, context, cb) => {
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
  },
};

const client = new Wit(token, actions);
client.interactive();