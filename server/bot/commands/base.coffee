# Command base class
module.exports = class Command
  constructor: () ->
  # Checks if this is an available Command
  # for this input and context
  # can be function, or regex
  filter: () ->
    throw new Error "Subclasses must implement `filter` function."
