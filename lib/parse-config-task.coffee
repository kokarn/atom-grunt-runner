# Nicholas Clawson - 05/02/2014 #

grunt = require 'grunt'

# attempts to load the gruntfile
module.exports = (path) ->
    try
        require(path)(grunt)
    catch e
        error = e.code

    return {error: error, tasks: Object.keys grunt.task._tasks}
