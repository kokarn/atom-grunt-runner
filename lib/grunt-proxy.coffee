module.exports = class GruntProxy
    constructor: ->
        @tasks = []

    initConfig:(options) ->

    loadNpmTasks:(task) ->

    registerTask:(task, subtasks) ->
        @tasks.push task
