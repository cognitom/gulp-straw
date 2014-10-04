detective = require 'detective'
coffee    = require 'coffee-script'

module.exports = (source, ext) ->
  compiled = switch ext
    when '.coffee' then coffee.compile source
    when '.js'     then source
    else '' # not supported yet
        
  detective compiled
  .filter (id) -> /^[^\.]/.test id # remove local modules
