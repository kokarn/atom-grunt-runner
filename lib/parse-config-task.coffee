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
        fn = require(gruntfilePath);
    catch e

    if !fn then return {error: "Gruntfile not found."}

    # change dir relative to gruntfile so Grunt will load
    # npm packages and other files from correct path
    process.chdir path.dirname gruntfilePath

    try
        fn(grunt)
    catch e
        error = e.code
        return {error: "Error parsing Gruntfile. " + e.message}

    return {tasks: Object.keys grunt.task._tasks}
