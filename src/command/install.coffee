Q          = require 'q'
_          = require 'underscore'
program    = require 'commander'
Task       = require '../task'
npmInstall = require '../npm-install'

to_install = []

command = ->
  args = program.rawArgs
  ids = []
  true while 'install' != args.shift()

  ids.push arg while /^\w/.test(arg = args.shift()) && arg

  dir = program.dir || ''

  Task.loadConfig()

  if ids.length
    tasks =
      for id in ids
        task = new Task id, dir
        task
    installTasks tasks
    .then ->
      Task.saveConfig()
      if to_install.length
        console.log "installing required modules in taskfiles..."
        npmInstall (_.uniq to_install), (err) ->
          console.log "[OK] installation completed"
  else
    installTasks Task.instances
    .then ->
      if to_install.length
        console.log "installing required modules in taskfiles..."
        npmInstall (_.uniq to_install), (err) ->
          console.log "[OK] installation completed"

installTask = (task) ->
  deferred = Q.defer()
  task.downloadFromGitHub (err) ->
    if err
      console.log "[NG] #{task.getQualifiedTaskName()} was not found"
    else
      console.log "[OK] #{task.getQualifiedTaskName()} > #{task.dist}"
      task.addToConfig()
      to_install.push d for d in task.dependencies
    deferred.resolve()
  deferred.promise

installTasks = (tasks) ->
  for dist, task of tasks when !task.ok
    console.log "[NG] <user>/<repo>:#{task.taskfile} needs user/repo field"

  Q.all promises =
    installTask task for dist, task of tasks when task.ok

module.exports = command
