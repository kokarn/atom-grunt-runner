###
Nicholas Clawson -2014

To be launched by an Atom Task, uses packages own grunt
installation to parse a projects Gruntfile
###
grunt = require 'grunt'
path = require 'path'

# attempts to load the gruntfile
module.exports = (gruntfilePath) ->
    fn = null;

    try
        # change dir relative to gruntfile so Grunt will load
        # npm packages and other files from correct path
        process.chdir path.dirname gruntfilePath

        fn = require(gruntfilePath);
    catch e

    if !fn then return {error: "Gruntfile not found.", path: gruntfilePath}

    try
        fn(grunt)
    catch e
        error = e.code
        return {error: "Error parsing Gruntfile. " + e.message, path: gruntfilePath}

    return {tasks: Object.keys grunt.task._tasks}
