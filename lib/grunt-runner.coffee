###
Nicholas Clawson -2014

Entry point for the package, creates the toolbar and starts
listening for any commands or changes
###
{CompositeDisposable} = require 'atom'

module.exports =
    config:
        panelStartsHidden:
            type: 'boolean'
            default: false
        gruntPaths:
            type: 'array'
            default: []
        gruntfilePaths:
            type: 'array'
            default: ['/Gruntfile', '/gruntfile']
    view: null

    # creates grunt-runner view and starts listening for commands
    activate: (@state) ->
        @state.attached ?= true if @shouldAttach()
        @state.attached = false unless @shouldAttach()

        @getView() if @state.attached

        @disposables = new CompositeDisposable
        @disposables.add(
            atom.commands.add 'atom-workspace',
                'grunt-runner:toggle-log': => @getView().toggleLog(),
                'grunt-runner:toggle-panel': => @getView().togglePanel(),
                'grunt-runner:run': => @getView().toggleTaskList(),
                'grunt-runner:run-latest': => @getView().runLatestTask(),
                'grunt-runner:stop': => @getView().stopProcess()

            atom.config.observe 'grunt-runner.gruntPaths', @getView().parseGruntFile.bind @view
        )

    # stops any currently running processes
    deactivate: ->
        @disposables.dispose()
        @view.stopProcess()
        @view?.deactivate()
        @view = null;

    serialize: ->
        if @view
            @view.serialize()
        else
            @state

    getView: ->
        unless @view?
            GruntRunnerView = require './grunt-runner-view.coffee'
            @view = new GruntRunnerView(@state)
        @view

    shouldAttach: ->
        # TODO this should attach only if there is a gruntfile and if config.panelStartsHidden is false
        gruntFileExists = true; # forced for now...
        gruntFileExists and not atom.config.get('grunt-runner.panelStartsHidden')
