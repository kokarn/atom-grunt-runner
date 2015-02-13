###
Nicholas Clawson -2014

Entry point for the package, creates the toolbar and starts
listening for any commands or changes
###

window.View = require './grunt-runner-view.coffee'

module.exports =
    configDefaults:
        gruntPaths: []

    # creates grunt-runner view andstarts listening for commands
    activate:(state = {}) ->
        @view = new View(state)
        atom.config.observe 'grunt-runner.gruntPaths', @view.parseGruntFile.bind @view
        atom.workspaceView.command 'grunt-runner:stop', @view.stopProcess.bind @view
        atom.workspaceView.command 'grunt-runner:toggle-log', @view.toggleLog.bind @view
        atom.workspaceView.command 'grunt-runner:toggle-panel', @view.togglePanel.bind @view
        atom.workspaceView.command 'grunt-runner:run', @view.toggleTaskList.bind @view


    # returns a JSON object representing the packages state
    serialize: ->
        @view.serialize()

    # stops any currently running processes
    deactivate: ->
        @view.stopProcess()
