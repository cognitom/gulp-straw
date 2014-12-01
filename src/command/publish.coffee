program = require 'commander'
netrc   = require 'node-netrc'
fs      = require 'fs'
Task    = require '../task'
auth    = netrc 'api.github.com'

command = ->
  args = program.rawArgs
  ids = []
  true while 'publish' != args.shift()
  ids.push arg while /^\w/.test(arg = args.shift()) && arg

  unless ids.length
    return

  Task.loadConfig()

  tasks =
    for id in ids
      task = new Task id
      task
  publishTasks tasks
  .then ->
    # TODO: Do something after publish

publishTask = (task) ->
  deferred = Q.defer()
  task.publishToGitHub (err) ->
    # TODO: Error handling
    deferred.resolve()
  deferred.promise

publishTasks = (tasks) ->
  Q.all promises =
    publishTask task for dist, task of tasks

module.exports = command
