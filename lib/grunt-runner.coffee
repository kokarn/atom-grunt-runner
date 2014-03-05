{BufferedProcess} = require 'atom'
window.View = require './results-view.coffee'

module.exports =

    # Activates the packages
    # tests for a gruntfile in the project directory
    # if one exists reads it and starts building the menu
    activate:(state = {}) ->
        @view = view = new View()

        atom.workspaceView.command 'grunt-runner:stop', @view.stopProcess.bind @view
        atom.workspaceView.command 'grunt-runner:toggle', @view.togglePanel.bind @view
        atom.workspaceView.command 'grunt-runner:default', ->
            view.input.attr 'value', 'default'
            view.startProcess()

    serialize: ->
        @view.serialize()
