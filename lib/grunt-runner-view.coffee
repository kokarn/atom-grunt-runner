# Nicholas Clawson - 05/02/2014 #

{View, BufferedProcess, Task} = require 'atom'
ListView = require './task-list-view'

module.exports = class ResultsView extends View

    path: null,
    process: null,
    taskList: null,

    # html layout
    @content: ->
        @div class: 'grunt-runner-results tool-panel panel-bottom native-key-bindings', =>
            @div class: 'grunt-panel-heading', =>
                @div outlet:'status', class: 'btn-group', =>
                    @button outlet:'startbtn', click:'openList', class:'btn', 'Start Grunt'
                    @button outlet:'stopbtn', click:'stopProcess', class:'btn', 'Stop Grunt'
                    @button outlet:'logbtn', click:'toggleLog', class:'btn', 'Toggle Log'
                    @button outlet:'panelbtn', click:'togglePanel', class:'btn', 'Hide'
            @div outlet:'panel', class: 'panel-body padded closed', =>
                @ul outlet:'errors', class: 'list-group'

    # called after the view is constructed
    #gets the projects current path and launches a task
    # to parse the projects gruntfile if it exists
    initialize:(state = {}) ->
        @path = atom.project.getPath();
        view = @

        @taskList = window.list = new ListView @startProcess.bind @

        @stopbtn.setTooltip "",
            command: 'grunt-runner:stop'

        @logbtn.setTooltip "",
            command: 'grunt-runner:toggle-log'

        @panelbtn.setTooltip "",
            command: 'grunt-runner:toggle-panel'

        @startProcess 'default'

        Task.once require.resolve('./parse-config-task'), atom.project.getPath()+'/gruntfile', (results)->
            {error, tasks} = results

            if error
                console.warn "grunt-runner: #{error}"
            else
                view.togglePanel()
                view.taskList.setItems tasks

    openList: ->
        @taskList.attach();

    # called to start the process
    # task name is gotten from the input element
    startProcess:(task) ->
        @stopProcess()
        @emptyPanel()
        @toggleLog() if @panel.hasClass 'closed'
        @status.attr 'data-status', 'loading'

        @addLine "Running : grunt #{task}", 'subtle'

        @gruntTask task, @path

    # stops the current process if it is running
    stopProcess: ->
        @addLine 'Grunt task was ended', 'warning' unless @process?.killed
        @process?.kill()
        @process = null
        @status.attr 'data-status', null

    togglePanel: ->
        return atom.workspaceView.prependToBottom @ unless @.isOnDom()
        return @.detach() if @.isOnDom()

    # hides and shows the log panel
    toggleLog: ->
        @panel.toggleClass 'closed'

    checkSelect:(evt) ->
        if evt.which == 13
            @startProcess()
            @input.blur()
            return false

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
        console.log 'running task ' + task + ' - ' + path
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
            args: []
            options: {cwd: path + '/'}
            stdout: stdout.bind @
            exit: exit.bind @
