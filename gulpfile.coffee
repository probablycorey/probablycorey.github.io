fs = require 'fs'

del = require("del")
gulp = require("gulp")
plugins = require("gulp-load-plugins")()

ERRORS= []

gulp.task "default", ["serve"]

gulp.task "serve", ["connect", "watch"], ->
  setTimeout((-> require("opn")("http://localhost:9000")), 1000)

gulp.task "build", ["static", "styles", "scripts"], ->
  if ERRORS.length > 0
    console.error error for error in ERRORS
    ansiRegex = /(?:(?:\u001b\[)|\u009b)(?:(?:[0-9]{1,3})?(?:(?:;[0-9]{0,3})*)?[A-M|f-m])|\u001b[A-M]/g
    fs.writeFileSync("dist/index.html", "<html><head></head><body><pre>#{ERRORS.join().replace(ansiRegex, '')}</pre></body></html>")
  ERRORS = []

gulp.task "clean", ->
  del("dist")

gulp.task "watch", ["build"], ->
  gulp.watch(["dist/**/*"])
    .on "change", (file) -> plugins.livereload().changed file.path

  gulp.watch "app/**/*", ["build"]

gulp.task "styles", ->
  gulp.src("app/**/*.less")
    .pipe(plugins.plumber(errorHandler: (error) -> ERRORS.push error))
    .pipe(plugins.less())
    .pipe(plugins.autoprefixer("last 1 version"))
    .pipe(gulp.dest("dist"))

gulp.task "scripts", ->
  gulp.src('app/**/*.coffee')
    .pipe(plugins.plumber(errorHandler: (error) -> ERRORS.push error))
    .pipe(plugins.sourcemaps.init())
    .pipe(plugins.coffee())
    .pipe(plugins.sourcemaps.write())
    .pipe(gulp.dest('dist'))

gulp.task "static", ->
  gulp.src(["app/**/*", "!app/**/*.{less,coffee}"])
    .pipe gulp.dest("dist")

gulp.task "connect", ["build"], ->
  connect = require("connect")
  serveIndex = require 'serve-index'
  serveStatic = require 'serve-static'
  app = connect()
    .use(require("connect-livereload")(port: 35729))
    .use(serveStatic("dist"))
    .use(serveIndex("dist"))

  require("http").createServer(app).listen(9000).on "listening", ->
    console.log "Started connect web server on http://localhost:9000"
