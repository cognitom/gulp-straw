(function() {
  var Task, auth, base64, client, fs, github, mkdirp, netrc, path;

  netrc = require('node-netrc');

  github = require('octonode');

  base64 = require('base64');

  fs = require('fs');

  path = require('path');

  mkdirp = require('mkdirp');

  Task = require('../task');

  auth = netrc('api.github.com');

  client = github.client({
    username: auth.login,
    password: auth.password
  });

  module.exports = function(task, alias) {
    var ghrepo, t;
    t = new Task(task, alias);
    if (!t.user) {
      console.log('User field needed');
      return;
    }
    console.log("install: " + (t.getQualifiedTaskName()) + " > " + t.dist);
    ghrepo = client.repo("" + t.user + "/" + t.repo);
    return ghrepo.contents("" + t.taskfile + "." + t.ext, function(err, data) {
      var dir, dist;
      dist = "" + t.dist + "." + t.ext;
      dir = path.dirname(dist);
      if (!fs.existsSync(dir)) {
        mkdirp.sync(dir);
      }
      return fs.writeFile(dist, base64.decode(data.content));
    });
  };

}).call(this);
