{spawn} = require 'spawn-cmd'
fs      = require 'fs'

# npm'api has no support for the external location.
# so we use npm via `spawn`.

module.exports = (dependencies, callback) ->
  if 'String' == typeof dependencies
    dependencies = [dependencies]
  
  # skip installed module
  config_path = "#{process.cwd()}/package.json" # TODO: support .npmrc
  if fs.existsSync config_path
    config = require config_path
  installed = config?.devDependencies || {}
  dependencies = dependencies.filter (d) -> !installed[d]?
  
  unless dependencies
    callback()
    return
  
  # prepare the command
  command = 'npm'
  args = []
  args.push 'install'
  args.push d for d in dependencies
  args.push '--save-dev'
  options = cwd: process.cwd()
  
  # invoke the command
  p = spawn command, args, options
  p.on 'close', -> callback() if callback