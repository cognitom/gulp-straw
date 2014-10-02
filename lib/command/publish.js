(function() {
  var Task, auth, fs, netrc;

  netrc = require('node-netrc');

  fs = require('fs');

  Task = require('../task');

  auth = netrc('api.github.com');

  module.exports = function(cmd) {
    return console.log("publish " + cmd);
  };

}).call(this);
