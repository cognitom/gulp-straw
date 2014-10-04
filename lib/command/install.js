(function() {
  var Q, Task, command, installTask, installTasks, npmInstall, program, to_install, _;

  Q = require('q');

  _ = require('underscore');

  program = require('commander');

  Task = require('../task');

  npmInstall = require('../npm-install');

  to_install = [];

  command = function() {
    var arg, args, dir, id, ids, tasks;
    args = program.rawArgs;
    ids = [];
    while ('install' !== args.shift()) {
      true;
    }
    while (/^\w/.test(arg = args.shift()) && arg) {
      ids.push(arg);
    }
    dir = program.dir || '';
    Task.loadConfig();
    if (ids.length) {
      tasks = (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = ids.length; _i < _len; _i++) {
          id = ids[_i];
          _results.push(new Task(id, dir));
        }
        return _results;
      })();
      return installTasks(tasks).then(function() {
        Task.saveConfig();
        console.log("installing required modules in taskfiles...");
        return npmInstall(_.uniq(to_install), function(err) {
          return console.log("[OK] installation completed");
        });
      });
    } else {
      return installTasks(Task.instances).then(function() {
        console.log("installing required modules in taskfiles...");
        return npmInstall(_.uniq(to_install), function(err) {
          return console.log("[OK] installation completed");
        });
      });
    }
  };

  installTask = function(task) {
    var deferred;
    deferred = Q.defer();
    task.downloadFromGitHub(function(err) {
      var d, _i, _len, _ref;
      if (err) {
        console.log("[NG] " + (task.getQualifiedTaskName()) + " was not found");
      } else {
        console.log("[OK] " + (task.getQualifiedTaskName()) + " > " + task.dist);
        task.addToConfig();
        _ref = task.dependencies;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          d = _ref[_i];
          to_install.push(d);
        }
      }
      return deferred.resolve();
    });
    return deferred.promise;
  };

  installTasks = function(tasks) {
    var dist, promises, task;
    return Q.all(promises = (function() {
      var _results;
      _results = [];
      for (dist in tasks) {
        task = tasks[dist];
        if (task.ok) {
          _results.push(installTask(task));
        }
      }
      return _results;
    })());
  };

  module.exports = command;

}).call(this);
