gulp   = require 'gulp'
coffee = require 'gulp-coffee'
meta   = require './package.json'

$ = meta.gulpvar

gulp.task 'default', ->
  gulp.src $.coffeeSrc
  .pipe coffee()
  .pipe gulp.dest $.coffeeDist

gulp.task 'watch', ->
  o = debounceDelay: 1000
  gulp.watch [$.coffeeSrc], o, ['default']