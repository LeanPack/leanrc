# including plugins
gulp    = require 'gulp'
coffee  = require 'gulp-coffee'

# task 'compile-coffee'
gulp.task 'compile_coffee', ()->
  gulp.src './api/**/*.coffee' # path to your file
  .pipe coffee()
  .pipe gulp.dest './dist'
  .on 'end', ->
    gulp.src './migrations/*.coffee' # path to your file
    .pipe coffee()
    .pipe gulp.dest './compiled_migrations'
