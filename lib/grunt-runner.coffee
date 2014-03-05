# Nicholas Clawson - 05/02/2014 #

window.View = require './grunt-runner-view.coffee'

module.exports =


    activate:(state = {}) ->
        @view = view = new View()

        atom.workspaceView.command 'grunt-runner:stop', @view.stopProcess.bind @view
        atom.workspaceView.command 'grunt-runner:toggle-log', @view.toggleLog.bind @view
        atom.workspaceView.command 'grunt-runner:toggle-panel', @view.togglePanel.bind @view
        atom.workspaceView.command 'grunt-runner:default', ->
            view.input.attr 'value', 'default'
            view.startProcess()

    serialize: ->
        @view.serialize()

    destory: ->
        @view.stopProcess()
