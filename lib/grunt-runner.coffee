###
Nicholas Clawson -2014

Entry point for the package, creates the toolbar and starts
listening for any commands or changes
###

window.View = require './grunt-runner-view.coffee'

module.exports =
    configDefaults:
        gruntPaths: []

    originalPath: ''

    # creates grunt-runner view andstarts listening for commands
    activate:(state = {}) ->
        @originalPath = process.env.PATH
        atom.config.observe 'grunt-runner.gruntPaths', @updateSettings.bind @

        @view = new View(state)
        atom.workspaceView.command 'grunt-runner:stop', @view.stopProcess.bind @view
        atom.workspaceView.command 'grunt-runner:toggle-log', @view.toggleLog.bind @view
        atom.workspaceView.command 'grunt-runner:toggle-panel', @view.togglePanel.bind @view
        atom.workspaceView.command 'grunt-runner:run', @view.toggleTaskList.bind @view

    # called whenever the settings for grunt runner changes
    # updates the env.process.PATH value to include custom paths
    updateSettings: ->
        gruntPaths = atom.config.get('grunt-runner').gruntPaths
        gruntPaths = if Array.isArray gruntPaths then gruntPaths else []
        process.env.PATH = @originalPath + (if gruntPaths.length > 0 then ':' else '') + gruntPaths.join ':'

    # returns a JSON object representing the packages state
    serialize: ->
        @view.serialize()

    # stops any currently running processes
    deactivate: ->
        @view.stopProcess()
