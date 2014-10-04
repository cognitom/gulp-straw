(function() {
  var Task, auth, fs, netrc, program;

  program = require('commander');

  netrc = require('node-netrc');

  fs = require('fs');

  Task = require('../task');

  auth = netrc('api.github.com');

  module.exports = function(cmd) {
    return console.log("🚧  update command is under development");
  };

}).call(this);
