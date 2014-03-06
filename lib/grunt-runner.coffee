# Nicholas Clawson - 05/02/2014 #

window.View = require './grunt-runner-view.coffee'

module.exports =
    configDefaults:
        gruntPaths: []

    activate:(state = {}) ->
        # all this stuff to make local grunt paths work
        # IT'S SO UGLY
        # TODO figure out a better way
        originalPath = process.env.PATH
        gruntPaths = atom.config.get('grunt-runner').gruntPaths
        gruntPaths = if Array.isArray gruntPaths then gruntPaths else []
        process.env.PATH = originalPath + (if gruntPaths.length > 0 then ':' else '') + gruntPaths.join ':'
        atom.config.observe 'grunt-runner.gruntPaths', ->
            gruntPaths = atom.config.get('grunt-runner').gruntPaths
            gruntPaths = if Array.isArray gruntPaths then gruntPaths else []
            process.env.PATH = originalPath + (if gruntPaths.length > 0 then ':' else '') + gruntPaths.join ':'

        @view = view = new View()
        atom.workspaceView.command 'grunt-runner:stop', @view.stopProcess.bind @view
        atom.workspaceView.command 'grunt-runner:toggle-log', @view.toggleLog.bind @view
        atom.workspaceView.command 'grunt-runner:toggle-panel', @view.togglePanel.bind @view
        atom.workspaceView.command 'grunt-runner:run', ->
            return view.taskList.attach() unless view.taskList.isOnDom()
            return view.taskList.cancel()


    serialize: ->
        @view.serialize()

    destroy: ->
        @view.stopProcess()
