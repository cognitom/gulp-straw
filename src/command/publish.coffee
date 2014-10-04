program = require 'commander'
netrc   = require 'node-netrc'
fs      = require 'fs'
Task    = require '../task'
auth    = netrc 'api.github.com'

module.exports = (cmd) ->
  console.log "🚧  publish command is under development"