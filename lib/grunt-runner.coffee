# Nicholas Clawson - 05/02/2014 #

window.View = require './grunt-runner-view.coffee'

module.exports =
    configDefaults:
        gruntPaths: []

    originalPath: ''

    activate:(state = {}) ->
        @originalPath = process.env.PATH
        atom.config.observe 'grunt-runner.gruntPaths', @updateSettings.bind @

        @view = new View(state)
        atom.workspaceView.command 'grunt-runner:stop', @view.stopProcess.bind @view
        atom.workspaceView.command 'grunt-runner:toggle-log', @view.toggleLog.bind @view
        atom.workspaceView.command 'grunt-runner:toggle-panel', @view.togglePanel.bind @view
        atom.workspaceView.command 'grunt-runner:run', @view.toggleTaskList.bind @view

    updateSettings: ->
        gruntPaths = atom.config.get('grunt-runner').gruntPaths
        gruntPaths = if Array.isArray gruntPaths then gruntPaths else []
        process.env.PATH = @originalPath + (if gruntPaths.length > 0 then ':' else '') + gruntPaths.join ':'

    serialize: ->
        @view.serialize()

    deactivate: ->
        @view.stopProcess()
