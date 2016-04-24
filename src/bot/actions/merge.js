'use strict';

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

module.exports = (sessionId, context, entities, message, cb) => {

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
};