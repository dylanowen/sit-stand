'use strict'

var gulp = require('gulp');
var ts = require('gulp-typescript');
var watch = require('gulp-watch');
var runSequence = require('run-sequence');
var del = require('del');

var config = {
    staticTargets : ['src/*.*', 'src/images/**/*.*'],
    tsSrc: {
        background: ['src/ts/**/*.ts', '!src/ts/**/*.d.ts']
    },
    buildDest: 'build/',
    ts: {
        noImplicitAny: true,
        out: 'js/main.js'
    }
};

gulp.task('clean', function(cb) {
    return del([config.buildDest + "*"]);
})

gulp.task('build:static', function() {
    return gulp.src(config.staticTargets, {base: 'src'})
        .pipe(gulp.dest(config.buildDest));
});
gulp.task('build:ts:background', function() {
    var tsConfig = config.ts;
    tsConfig.out = 'js/background.js';

    return gulp.src(config.tsSrc.background)
        .pipe(ts(tsConfig))
        .pipe(gulp.dest(config.buildDest));
});
gulp.task('build', function(cb) {
    runSequence('clean', ['build:static', 'build:ts:background'], cb);
});

gulp.task('default', ['build']);