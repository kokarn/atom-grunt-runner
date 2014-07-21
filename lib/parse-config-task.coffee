###
Nicholas Clawson -2014

To be launched by an Atom Task, uses packages own grunt
installation to parse a projects Gruntfile
###

grunt = require 'grunt'
path = require 'path'

# attempts to load the gruntfile
module.exports = (path) ->
    try
        #this does not work while the gruntfile is not in the workspace root directory
        # require(path)(grunt)
        grunt = require(path.join path, "/node_modules/grunt")
        gruntfile=findup 'Gruntfile.{js,coffee}', {cwd: path,nocase: true}
        grunt.option 'gruntfile',gruntfile
        grunt.task.init [], {}
    catch e
        error = e.code

    return {error: error, tasks: Object.keys grunt.task._tasks}
