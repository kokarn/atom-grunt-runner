{View, BufferedProcess} = require 'atom'
grunt = require 'grunt'

module.exports = class ResultsView extends View

    path: null,
    process: null,

    @content: ->
        @div class: 'grunt-runner-results tool-panel panel-bottom', =>
            @div class: 'panel-heading', =>
                @input outlet:'input', class: 'editor mini editor-colors', value: 'default'
                @button click:'startProcess', class:'btn', 'Start Grunt'
                @button click:'stopProcess', class:'btn', 'Stop Grunt'
                @button click:'togglePanel', class:'btn', 'Toggle Log'
            @div outlet:'panel', class: 'panel-body padded closed', =>
                @ul outlet:'errors', class: 'list-group'

    initialize:(state = {}) ->
        @path = atom.project.getPath();

        try
            require(atom.project.getPath()+'/gruntfile')(grunt)
            atom.workspaceView.prependToBottom @
        catch e
            console.warn 'grunt-runner: ' + e

        Object.keys(grunt.task._tasks).forEach (task) ->
            console.log task



    startProcess: ->
        @stopProcess()
        @emptyPanel()
        @togglePanel if @panel.hasClass 'closed'

        task = @input.attr 'value'
        @addLine "Running : grunt #{task}", 'subtle'

        @gruntTask task, @path

    stopProcess: ->
        @addLine 'Grunt task was ended', 'warning' if @process?.killed
        @process?.kill()
        @process = null

    togglePanel: ->
        @panel.toggleClass 'closed'

    addLine:(text, type = "plain") ->
        [panel, errorList] = [@panel, @errors]
        stuckToBottom = errorList.height() - panel.height() - panel.scrollTop() == 0
        errorList.append "<li class='text-#{type}'>#{text}</li>"
        panel.scrollTop errorList.height() if stuckToBottom

    emptyPanel: ->
        @errors.empty()

    serialize: ->
        return {}

    gruntTask:(task, path) ->

        stdout = (out) ->
            @addLine out.replace /\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]/g, ''
        exit = (code) ->
            atom.beep() unless code == 0
            @addLine "Grunt exited: code #{code}.", if code == 0 then 'success' else 'error'

        @process = new BufferedProcess
            command: 'grunt'
            args: [task]
            options: {cwd: path}
            stdout: stdout.bind @
            exit: exit.bind @
