(function() {
  var meta, program;

  program = require('commander');

  meta = require('../package.json');

  program.version(meta.version);

  program.command('install <task> [alias]').description('install gulpfile <task> from GitHub').action(require('./command/install'));

  program.command('update <task>').description('update gulpfile <task> from GitHub').action(require('./command/update'));

  program.command('publish <task>').description('publish gulpfile <task> to GitHub').action(require('./command/publish'));

  program.parse(process.argv);

}).call(this);
