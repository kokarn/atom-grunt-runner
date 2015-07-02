###
Nicholas Clawson -2014

Entry point for the package, creates the toolbar and starts
listening for any commands or changes
###

window.View = require './grunt-runner-view.coffee'

module.exports =
    config:
        gruntPaths:
            type: 'array'
            default: []

    # creates grunt-runner view and starts listening for commands
    activate:(state = {}) ->
        @view = new View(state)
        atom.config.observe 'grunt-runner.gruntPaths', @view.parseGruntFile.bind @view
        atom.commands.add 'atom-workspace', 'grunt-runner:stop', @view.stopProcess.bind @view
        atom.commands.add 'atom-workspace', 'grunt-runner:toggle-log', @view.toggleLog.bind @view
        atom.commands.add 'atom-workspace', 'grunt-runner:toggle-panel', @view.togglePanel.bind @view
        atom.commands.add 'atom-workspace', 'grunt-runner:run', @view.toggleTaskList.bind @view
        atom.commands.add 'atom-workspace', 'grunt-runner:run-latest', @view.runLatestTask.bind @view


    # returns a JSON object representing the packages state
    serialize: ->
        @view.serialize()

    # stops any currently running processes
    deactivate: ->
        @view.stopProcess()
