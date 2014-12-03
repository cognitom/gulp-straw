merge    = require 'merge'
path     = require 'path'

gatTaskName = () ->
  Error.prepareStackTrace = (e, st) ->
    st[1].getFileName() # st[0] is a current file

  obj = {}
  Error.captureStackTrace obj, gatTaskName
  filename = obj.stack

  path.relative process.cwd(), filename
    .replace /\..+?$/, '' # remove extension

override = (vars, config_file='package.json') ->
  taskname = gatTaskName()
  config = require path.resolve config_file
  vars = merge vars, config.gulpvars[taskname] if config.gulpvars?[taskname]?
  false

module.exports =
  override: override
