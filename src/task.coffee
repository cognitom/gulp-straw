netrc   = require 'node-netrc'
auth    = netrc 'api.github.com'

module.exports = class Task
  constructor: (src, @dist = '') ->
    @user = auth.login || ''
    @repo = 'gulpfiles'
    @taskfile = 'gulpfile'
    @ext = 'coffee'
    
    # normalize
    [all, @taskfile] = m if m = src.match /^([\w\/]+)$/
    [all, @user, @taskfile] = m if m = src.match /^(\w+):([\w\/]+)$/
    [all, @user, @repo, @taskfile] = m if m = src.match /^(\w+)\/(\w+):([\w\/]+)$/
    
    # complement dist
    @dist = @dist + (@taskfile.split '/').pop() if /\/$/.test @dist
    @dist = @taskfile unless @dist
    
    @
    
  getQualifiedTaskName: ->
    name = @user
    name += "/#{@repo}" if 'gulpfiles' != @repo
    name += ":#{@taskfile}"
    name += ".#{@ext}" if @ext
    name
