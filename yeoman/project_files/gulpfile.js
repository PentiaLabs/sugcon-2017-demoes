var gulp = require('gulp');
var runSequence = require('run-sequence');
var publish = require('@pentia/publish-projects');
var packagemanager = require('@pentia/sitecore-package-manager');
var configTransform = require('@pentia/configuration-transformer');
var watchprojects = require('@pentia/watch-publish-projects');
var rimraf = require('rimraf');
var fs = require('fs-extra');

gulp.task('Setup-Development-Environment', function(callback) {
	runSequence(
		'delete-website',
		'install-packages',
		'publish-all-layers',
		'apply-xml-transform',
		'copy-license',
		callback);
});

gulp.task('setup', function(callback) {
	runSequence('Setup-Development-Environment',
		callback);
});

gulp.task('delete-website', function(callback) {
	rimraf('C:\\websites\\sugcon.local\\Website', callback);
});

gulp.task('copy-license', function() {
	fs.copy('C:\\license\\license.xml', 'C:\\websites\\sugcon.local\\Website\\Data\\license.xml');
});