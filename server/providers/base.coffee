module.exports = class BaseProvider
  search: (query, options, callback) ->
    throw new Error "Must reimplement `search` function"
