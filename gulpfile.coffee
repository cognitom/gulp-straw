gulp   = require 'gulp'
coffee = require 'gulp-coffee'
del    = require 'del'
mkdirp = require 'mkdirp'
meta   = require './package.json'

$ = meta.gulpvars

gulp.task 'default', ->
  gulp.src $.coffeeSrc
  .pipe coffee()
  .pipe gulp.dest $.coffeeDist
  
gulp.task 'clear-sandbox', (cb) ->
  sandbox = './test/sandbox'
  del ["#{sandbox}/**/*"], ->
    mkdirp.sync sandbox
    cb()

gulp.task 'watch', ->
  o = debounceDelay: 1000
  gulp.watch [$.coffeeSrc], o, ['default']