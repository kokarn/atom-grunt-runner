grunt = require 'grunt'

module.exports = (path) ->
    try
        require(path)(grunt)
    catch e
        error = e.code

    return {error: error, classes: Object.keys grunt.task._tasks}
