Q         = require 'q'
netrc     = require 'node-netrc'
github    = require 'octonode'
base64    = require 'base64'
fs        = require 'fs'
path      = require 'path'
mkdirp    = require 'mkdirp'
detective = require './detective'
auth      = netrc 'api.github.com'

client =
  if auth && auth.login
    github.client
      username: auth.login
      password: auth.password
  else
    github.client() # public access

config = {}
config_path = "#{process.cwd()}/package.json" # TODO: support .npmrc
config_src = '{}'
config_key = 'gulpfiles'

tasks = {}

class Task
  @instances: tasks

  @loadConfig: ->
    if fs.existsSync config_path
      config = require config_path
      config_src = fs.readFileSync(config_path).toString()
    config[config_key] = {} unless config[config_key]?

    re = /\/[^\/]+$/
    for dist, taskName of config[config_key]
      dir = ''
      dir = dist.replace re, '' if re.test dist
      new Task taskName, dir

  # save config to package.json
  @saveConfig: ->
    injectPart = (src, name, data) ->
      re = new RegExp "\"#{name}\"\\s*:\\s*\\{[^\\}]+?\\}", 'm'
      json = JSON.stringify data, null, '  ' # double spaces
      part = "\"#{name}\": " + json.replace /\n/g, '\n  ' # indentation
      unless re.test src
        re = /\s*\}\s*$/
        part = "\n  #{part}\n}\n"
        part = ",#{part}" unless /^\s*\{\s*\}\s*$/m.test config_src
      src.replace re, part

    config_src = injectPart config_src, config_key, config[config_key]
    fs.writeFileSync config_path, config_src

  constructor: (src, dir = '') ->
    @ok = true
    @user = auth.login || ''
    @repo = 'gulpfiles'
    @taskfile = 'gulpfile'
    @dependencies = []

    # <path/to/taskfile>
    # <user>:<path/to/taskfile>
    # <user>/<repo>:<path/to/taskfile>
    [all, @taskfile] = m if m = src.match /^([\w\/]+)$/
    [all, @user, @taskfile] = m if m = src.match /^(\w+):([\w\/]+)$/
    [all, @user, @repo, @taskfile] = m if m = src.match /^(\w+)\/(\w+):([\w\/]+)$/

    # location to install taskfile
    @dist = @taskfile
    @dist = dir.replace(/\/$/, '') + '/' + (@dist.split '/').pop() if dir

    @ok = false unless @user

    tasks[@dist] = @
    @

  getQualifiedTaskName: ->
    name = @user
    name += "/#{@repo}" if 'gulpfiles' != @repo
    name += ":#{@taskfile}"
    name

  addToConfig: ->
    config[config_key][@dist] = @getQualifiedTaskName()

    sortObject = (obj) ->
      sorted = {}
      for key in Object.keys(obj).sort()
        sorted[key] = obj[key]
      sorted

    config[config_key] = sortObject config[config_key]

  downloadFromGitHub: (callback) ->
    taskfile = @taskfile

    resolveExtension = (tree) =>
      for item in tree when 'blob' == item.type
        if taskfile == item.path.replace /\.\w+$/, ''
          ext = (item.path.match /\.\w+$/)[0]
          return ext
      false

    saveTaskfile = (content, ext) =>
      dir = path.dirname @dist
      mkdirp.sync dir unless fs.existsSync dir
      fs.writeFile "#{@dist}#{ext}", content
      @dependencies = detective content, ext

    ghrepo = client.repo "#{@user}/#{@repo}"
    ghrepo.info (err, data) ->
      branch_name = data.default_branch
      ghrepo.branch branch_name, (err, data) ->
        sha = data.commit.sha
        ghrepo.tree sha, true, (err, data) ->
          unless ext = resolveExtension data.tree
            callback 'no such a file'
            return
          ghrepo.contents "#{taskfile}#{ext}", (err, data) =>
            saveTaskfile (base64.decode data.content), ext
            callback()

  publishToGitHub: ->
    deferred = Q.defer()

      # TODO: publish a file via GitHub API

    deferred.promise

module.exports = Task
