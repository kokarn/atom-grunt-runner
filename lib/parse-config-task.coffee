###
Nicholas Clawson -2014

To be launched by an Atom Task, uses packages own grunt
installation to parse a projects Gruntfile
###
grunt = require 'grunt'

# attempts to load the gruntfile
module.exports = (path) ->
    fn = null;

    try
        fn = require(path);
    catch e

    if !fn then return {error: "Gruntfile not found."}

    try
        fn(grunt)
    catch e
        error = e.code
        return {error: "Error parsing Gruntfile. " + e.message}

    return {tasks: Object.keys grunt.task._tasks}
