(function() {
  var fs, spawn;

  spawn = require('spawn-cmd').spawn;

  fs = require('fs');

  module.exports = function(dependencies, callback) {
    var args, command, config, config_path, d, installed, options, p, _i, _len;
    if ('String' === typeof dependencies) {
      dependencies = [dependencies];
    }
    config_path = "" + (process.cwd()) + "/package.json";
    if (fs.existsSync(config_path)) {
      config = require(config_path);
    }
    installed = (config != null ? config.devDependencies : void 0) || {};
    dependencies = dependencies.filter(function(d) {
      return installed[d] == null;
    });
    if (!dependencies) {
      callback();
      return;
    }
    command = 'npm';
    args = [];
    args.push('install');
    for (_i = 0, _len = dependencies.length; _i < _len; _i++) {
      d = dependencies[_i];
      args.push(d);
    }
    args.push('--save-dev');
    options = {
      cwd: process.cwd()
    };
    p = spawn(command, args, options);
    return p.on('close', function() {
      if (callback) {
        return callback();
      }
    });
  };

}).call(this);
