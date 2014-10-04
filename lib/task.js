(function() {
  var Task, auth, base64, client, config, config_key, config_path, config_src, detective, fs, github, mkdirp, netrc, path, tasks;

  netrc = require('node-netrc');

  github = require('octonode');

  base64 = require('base64');

  fs = require('fs');

  path = require('path');

  mkdirp = require('mkdirp');

  detective = require('./detective');

  auth = netrc('api.github.com');

  client = github.client({
    username: auth.login,
    password: auth.password
  });

  config = {};

  config_path = "" + (process.cwd()) + "/package.json";

  config_src = '{}';

  config_key = 'gulpfiles';

  tasks = {};

  Task = (function() {
    Task.instances = tasks;

    Task.loadConfig = function() {
      var dir, dist, re, taskName, _ref, _results;
      if (fs.existsSync(config_path)) {
        config = require(config_path);
        config_src = fs.readFileSync(config_path).toString();
      }
      if (config[config_key] == null) {
        config[config_key] = {};
      }
      re = /\/[^\/]+$/;
      _ref = config[config_key];
      _results = [];
      for (dist in _ref) {
        taskName = _ref[dist];
        dir = '';
        if (re.test(dist)) {
          dir = dist.replace(re, '');
        }
        _results.push(new Task(taskName, dir));
      }
      return _results;
    };

    Task.saveConfig = function() {
      var injectPart;
      injectPart = function(src, name, data) {
        var json, part, re;
        re = new RegExp("\"" + name + "\"\\s*:\\s*\\{[^\\}]+?\\}", 'm');
        json = JSON.stringify(data, null, '  ');
        part = ("\"" + name + "\": ") + json.replace(/\n/g, '\n  ');
        if (!re.test(src)) {
          re = /\s*\}\s*$/;
          part = "\n  " + part + "\n}\n";
          if (!/^\s*\{\s*\}\s*$/m.test(config_src)) {
            part = "," + part;
          }
        }
        return src.replace(re, part);
      };
      config_src = injectPart(config_src, config_key, config[config_key]);
      return fs.writeFileSync(config_path, config_src);
    };

    function Task(src, dir) {
      var all, m;
      if (dir == null) {
        dir = '';
      }
      this.ok = true;
      this.user = auth.login || '';
      this.repo = 'gulpfiles';
      this.taskfile = 'gulpfile';
      this.dependencies = [];
      if (m = src.match(/^([\w\/]+)$/)) {
        all = m[0], this.taskfile = m[1];
      }
      if (m = src.match(/^(\w+):([\w\/]+)$/)) {
        all = m[0], this.user = m[1], this.taskfile = m[2];
      }
      if (m = src.match(/^(\w+)\/(\w+):([\w\/]+)$/)) {
        all = m[0], this.user = m[1], this.repo = m[2], this.taskfile = m[3];
      }
      this.dist = this.taskfile;
      if (dir) {
        this.dist = dir.replace(/\/$/, '') + '/' + (this.dist.split('/')).pop();
      }
      if (!this.user) {
        this.ok = false;
      }
      tasks[this.dist] = this;
      this;
    }

    Task.prototype.getQualifiedTaskName = function() {
      var name;
      name = this.user;
      if ('gulpfiles' !== this.repo) {
        name += "/" + this.repo;
      }
      name += ":" + this.taskfile;
      return name;
    };

    Task.prototype.addToConfig = function() {
      var sortObject;
      config[config_key][this.dist] = this.getQualifiedTaskName();
      sortObject = function(obj) {
        var key, sorted, _i, _len, _ref;
        sorted = {};
        _ref = Object.keys(obj).sort();
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          key = _ref[_i];
          sorted[key] = obj[key];
        }
        return sorted;
      };
      return config[config_key] = sortObject(config[config_key]);
    };

    Task.prototype.downloadFromGitHub = function(callback) {
      var ghrepo, resolveExtension, saveTaskfile, taskfile;
      taskfile = this.taskfile;
      resolveExtension = (function(_this) {
        return function(tree) {
          var ext, item, _i, _len;
          for (_i = 0, _len = tree.length; _i < _len; _i++) {
            item = tree[_i];
            if ('blob' === item.type) {
              if (taskfile === item.path.replace(/\.\w+$/, '')) {
                ext = (item.path.match(/\.\w+$/))[0];
                return ext;
              }
            }
          }
          return false;
        };
      })(this);
      saveTaskfile = (function(_this) {
        return function(content, ext) {
          var dir;
          dir = path.dirname(_this.dist);
          if (!fs.existsSync(dir)) {
            mkdirp.sync(dir);
          }
          fs.writeFile("" + _this.dist + ext, content);
          return _this.dependencies = detective(content, ext);
        };
      })(this);
      ghrepo = client.repo("" + this.user + "/" + this.repo);
      return ghrepo.info(function(err, data) {
        var branch_name;
        branch_name = data.default_branch;
        return ghrepo.branch(branch_name, function(err, data) {
          var sha;
          sha = data.commit.sha;
          return ghrepo.tree(sha, true, function(err, data) {
            var ext;
            if (!(ext = resolveExtension(data.tree))) {
              callback('no such a file');
              return;
            }
            return ghrepo.contents("" + taskfile + ext, (function(_this) {
              return function(err, data) {
                saveTaskfile(base64.decode(data.content), ext);
                return callback();
              };
            })(this));
          });
        });
      });
    };

    return Task;

  })();

  module.exports = Task;

}).call(this);
