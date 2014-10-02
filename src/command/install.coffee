netrc     = require 'node-netrc'
github    = require 'octonode'
base64    = require 'base64'
fs        = require 'fs'
path      = require 'path'
mkdirp    = require 'mkdirp'
Task      = require '../task'

auth = netrc 'api.github.com'
client = github.client
  username: auth.login
  password: auth.password
  
module.exports = (task, alias) ->
  t = new Task task, alias
  
  unless t.user
    console.log 'User field needed'
    return
    
  console.log "install: #{t.getQualifiedTaskName()} > #{t.dist}"
  
  ghrepo = client.repo "#{t.user}/#{t.repo}"
  
  
  
  ghrepo.contents "#{t.taskfile}.#{t.ext}", (err, data) ->
    dist = "#{t.dist}.#{t.ext}"
    dir = path.dirname dist
    mkdirp.sync dir unless fs.existsSync dir
    fs.writeFile dist, base64.decode data.content