var grunt = require('grunt');

require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks);

module.exports = function () {
	var config = {};

	grunt.initConfig({
		pkg: grunt.file.readJSON('package.json'),
		coffee: {
			compile: {
				options: {
					sourceMap: true
				},
				files: {
					'lib/plugin.js': 'src/plugin.litcoffee'
				}
			},
		},
		watch: {
			coffee: {
				files : ['src/plugin.litcoffee'],
				tasks : ['coffee']
			}
		}
	});

	grunt.registerTask('default', ['coffee','watch']);

};
