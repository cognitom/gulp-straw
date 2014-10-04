Q        = require 'q'
program  = require 'commander'
promptly = require 'promptly'
netrc    = require 'netrc'
github   = require 'octonode'
fs       = require 'fs'
path     = require 'path'
open     = require 'open'
Task     = require '../task'

MACHINE  = 'api.github.com'

module.exports = (cmd) ->
  console.log "------------------------------------------------------------"
  console.log "Straw requires you to auth with GitHub."
  console.log "You can create a new token here:"
  console.log "🔖  https://github.com/settings/tokens/new"
  console.log "------------------------------------------------------------"
  
  # TODO: check and confirm to overwrite existing setting
  
  ghuser = ''
  ghtoken = ''
  
  askGHAccount()
  .then (data) ->
    ghuser = data
    askOpenBrowser()
  .then ->
    askGHToken()
  .then (data) ->
    ghtoken = data
    checkGHAccount ghuser, ghtoken
  .then ->
    saveAccount ghuser, ghtoken
  
askGHAccount = ->
  deferred = Q.defer()
  promptly.prompt '👤  GitHub account:',
    validator: (value) ->
      unless /^[a-zA-Z0-9\-]+$/.test value
        throw new Error '💡  Alphanumeric characters or dashes'
      value
  , (err, data) ->
    deferred.resolve data
  deferred.promise

askOpenBrowser = ->
  deferred = Q.defer()
  promptly.confirm '💬  Open the browser to get your token? (YES/no)',
    default: 'yes'
  , (err, flag) ->
    open 'https://github.com/settings/tokens/new' if flag
    deferred.resolve()
  deferred.promise
  
askGHToken = ->
  deferred = Q.defer()
  promptly.prompt '🔑  Paste here:',
    validator: (value) ->
      unless /^[a-f0-9]+$/.test value
        throw new Error '💡  The token may be hex characters, check it.'
      value
  , (err, data) ->
    deferred.resolve data
  deferred.promise
    
checkGHAccount = (ghuser, ghtoken) ->
  deferred = Q.defer()
  client = github.client
    username: ghuser
    password: ghtoken
  ghme = client.me()
  ghme.info (err, data, headers) ->
    console.log "------------------------------------------------------------"
    unless err
      console.log "Successfully access to your GitHub account!"
      console.log "- Name: #{data.name}"
      console.log "- Mail: #{data.email}"
    deferred.resolve()
  deferred.promise
    
saveAccount = (login, password) ->
  machines = netrc()
  machines[MACHINE] = 
    login: login
    password: password
  home = process.env.HOME || process.env.HOMEPATH
  file = path.join home, '.netrc'
  fs.writeFile file, netrc.format machines
  
  console.log "The account '#{login}' was saved into ~/.netrc."
  console.log "------------------------------------------------------------"
