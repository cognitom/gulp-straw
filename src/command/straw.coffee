program = require 'commander'
meta    = require '../../package.json'

program
.version meta.version
.option '-D, --dir <path>', 'change the installation directory (for only `install`)'

program
.command 'setup'
.description 'setup your account of GitHub'
.action require './setup'

program
.command 'install [task]'
.description 'install gulpfile <task> from GitHub'
.action require './install'
    
program
.command 'update [task]'
.description 'update gulpfile <task> from GitHub'
.action require './update'

program
.command 'publish <task>'
.description 'publish gulpfile <task> to GitHub'
.action require './publish'
  
program.parse process.argv