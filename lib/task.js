(function() {
  var Task, auth, netrc;

  netrc = require('node-netrc');

  auth = netrc('api.github.com');

  module.exports = Task = (function() {
    function Task(src, dist) {
      var all, m;
      this.dist = dist != null ? dist : '';
      this.user = auth.login || '';
      this.repo = 'gulpfiles';
      this.taskfile = 'gulpfile';
      this.ext = 'coffee';
      if (m = src.match(/^([\w\/]+)$/)) {
        all = m[0], this.taskfile = m[1];
      }
      if (m = src.match(/^(\w+):([\w\/]+)$/)) {
        all = m[0], this.user = m[1], this.taskfile = m[2];
      }
      if (m = src.match(/^(\w+)\/(\w+):([\w\/]+)$/)) {
        all = m[0], this.user = m[1], this.repo = m[2], this.taskfile = m[3];
      }
      if (/\/$/.test(this.dist)) {
        this.dist = this.dist + (this.taskfile.split('/')).pop();
      }
      if (!this.dist) {
        this.dist = this.taskfile;
      }
      this;
    }

    Task.prototype.getQualifiedTaskName = function() {
      var name;
      name = this.user;
      if ('gulpfiles' !== this.repo) {
        name += "/" + this.repo;
      }
      name += ":" + this.taskfile;
      if (this.ext) {
        name += "." + this.ext;
      }
      return name;
    };

    return Task;

  })();

}).call(this);
