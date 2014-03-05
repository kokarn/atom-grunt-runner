# Nicholas Clawson - 05/02/2014 #

{View, BufferedProcess, Task} = require 'atom'

module.exports = class ResultsView extends View

    path: null,
    process: null,

    # html layout
    @content: ->
        @div class: 'grunt-runner-results tool-panel panel-bottom', =>
            @div outlet: 'status', class: 'panel-heading', =>
                @input outlet:'input', class: 'editor mini editor-colors', value: 'default'
                @button click:'startProcess', class:'btn', 'Start Grunt'
                @button click:'stopProcess', class:'btn', 'Stop Grunt'
                @button click:'togglePanel', class:'btn', 'Toggle Log'
            @div outlet:'panel', class: 'panel-body padded closed', =>
                @ul outlet:'errors', class: 'list-group'

    # called after the view is constructed
    #gets the projects current path and launches a task
    # to parse the projects gruntfile if it exists
    initialize:(state = {}) ->
        @path = atom.project.getPath();
        view = @

        Task.once require.resolve('./build-menu'), atom.project.getPath()+'/gruntfile', (results)->
            {error, classes} = results

            if error
                console.warn "grunt-runner: #{error}"
            else
                atom.workspaceView.prependToBottom view

    # called to start the process
    # task name is gotten from the input element
    startProcess: ->
        @stopProcess()
        @emptyPanel()
        @togglePanel() if @panel.hasClass 'closed'
        @status.attr 'data-status', 'loading'

        task = @input[0].value
        @addLine "Running : grunt #{task}", 'subtle'

        @gruntTask task, @path

    # stops the current process if it is running
    stopProcess: ->
        @addLine 'Grunt task was ended', 'warning' unless @process?.killed
        @process?.kill()
        @process = null
        @status.attr 'data-status', null

    # hides and shows the log panel
    togglePanel: ->
        @panel.toggleClass 'closed'

    # adds an entry to the log
    # converts all newlines to <br>
    addLine:(text, type = "plain") ->
        [panel, errorList] = [@panel, @errors]
        text = text.trim().replace /[\r\n]+/g, '<br />'
        stuckToBottom = errorList.height() - panel.height() - panel.scrollTop() == 0
        errorList.append "<li class='text-#{type}'>#{text}</li>"
        panel.scrollTop errorList.height() if stuckToBottom

    # clears the log
    emptyPanel: ->
        @errors.empty()

    # TODO
    serialize: ->
        return {}

    # launches an Atom BufferedProcess
    gruntTask:(task, path) ->

        stdout = (out) ->
            # removed color commands,  borrowed from
            # https://github.com/Filirom1/stripcolorcodes (MIT license)
            @addLine out.replace /\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]/g, ''
        exit = (code) ->
            atom.beep() unless code == 0
            @addLine "Grunt exited: code #{code}.", if code == 0 then 'success' else 'error'
            @status.attr 'data-status', if code == 0 then 'ready' else 'error'

        @process = new BufferedProcess
            command: 'grunt'
            args: [task]
            options: {cwd: path}
            stdout: stdout.bind @
            exit: exit.bind @
