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

    # get all tasks and subtasks
    tasks = []
    for own task of grunt.task._tasks
        raws = Object.keys grunt.config.get(task) or {}
        subs = (sub for sub in raws when sub not in ["files", "options", "globals"])
        tasks.push String task
        tasks.push "#{task}:#{sub}" for sub in subs if subs.length > 1

    return {tasks: tasks}
