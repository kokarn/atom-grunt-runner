###
Nicholas Clawson -2014

The bottom toolbar. In charge handling user input and implementing
various commands. Creates a SelectListView and launches a task to
discover the projects grunt commands. Logs errors and output.
Also launches an Atom BufferedProcess to run grunt when needed.
###

{BufferedProcess, Task, CompositeDisposable} = require 'atom'
{View, $} = require 'atom-space-pen-views'
ListView = require './task-list-view'
path = require 'path'

module.exports = class GruntRunnerView extends View
    path: null,
    process: null,
    taskList: null,
    tasks: [],
    cwd: null,
    failuresLog: [],
    originalPaths: process.env.NODE_PATH.split(':'),
    gruntRunnerPannel: null,

    # html layout
    @content: ->
        @div class: 'grunt-runner-resizer tool-panel panel-bottom', =>
          @div class: 'grunt-runner-resizer-handle'
          @div outlet: 'container', class: 'grunt-runner-results tool-panel native-key-bindings', =>
              @div outlet:'status', class: 'grunt-panel-heading', =>
                  @div class: 'btn-group', =>
                      @button outlet:'startstopbtn', click:'startStopAction', class:'btn', 'Start Grunt'
                      @button outlet:'logbtn', click:'toggleLog', class:'btn', 'Toggle Log'
                      @button outlet:'panelbtn', click:'togglePanel', class:'btn', 'Hide'
              @div outlet:'panel', class: 'panel-body padded', tabindex: -1, =>
                  @ul outlet:'errors', class: 'list-group'

    # called after the view is constructed
    # initialize list and triggers processing of the gruntfile
    initialize: (state) ->
        @taskList = new ListView
        @disposables = new CompositeDisposable
        @disposables.add(
            atom.project.onDidChangePaths => @parseGruntFile()

            atom.tooltips.add @startstopbtn,
                title: "Start",
                keyBindingCommand: 'grunt-runner:run'

            atom.tooltips.add @logbtn,
                title: "",
                keyBindingCommand: 'grunt-runner:toggle-log'

            atom.tooltips.add @panelbtn,
                title: "",
                keyBindingCommand: 'grunt-runner:toggle-panel'
        )
        @handleEvents()
        @attach() if state.attached

    deactivate: ->
        @disposables.dispose()
        @detach() if @gruntRunnerPannel?

    serialize: ->
        attached: @gruntRunnerPannel?

    attach: ->
        @gruntRunnerPannel = atom.workspace.addBottomPanel(item: this)

    detach: ->
        @gruntRunnerPannel.destroy()
        @gruntRunnerPannel = null

    # launches a task to parse the projects gruntfile if it exists
    parseGruntFile:(starting) ->
        @paths = atom.project.getPaths()

        # Assume the "real" paths is the first path.
        # TODO: Real fix
        @path = @paths[0]

        gruntPaths = atom.config.get('grunt-runner.gruntPaths')
        gruntPaths = if Array.isArray gruntPaths then gruntPaths else []
        paths = @originalPaths.concat(gruntPaths, [@path + '/node_modules'])
        process.env.NODE_PATH = paths.join(path.delimiter)

        # clear panel output and tasklist items
        @emptyPanel()
        @status.attr 'data-status', null

        if !@path
            @addLine "No project opened."
        else
            path = @path
            @testPaths = atom.config.get('grunt-runner.gruntfilePaths').map (e) -> "#{path}#{e}"
            Task.once require.resolve('./parse-config-task'), @testPaths[0], ({error, tasks, path}) => @handleTask(@, error, tasks, path, 0)

    handleEvents: ->
        @on 'mousedown', '.grunt-runner-resizer-handle', (e) => @resizeStarted(e)

    handleTask: (view, error, tasks, path, index) ->
      if error
          # does not display the log directly, waits until all attempts have failed
          @failuresLog.push("Error loading gruntfile: #{error} (#{path})")

          if @testPaths[(index + 1)] && error == "Gruntfile not found."
            Task.once require.resolve('./parse-config-task'), @testPaths[(index + 1)], ({error, tasks, path}) => @handleTask(view, error, tasks, path, (index + 1))

          # all gruntfile possibilities have failed, show all logs
          if !@testPaths[(index + 1)]
              for i in [0...(index + 1)]
                  view.addLine(@failuresLog[i], "error")

              view.toggleLog()
      else
          view.addLine "Grunt file parsed, found #{tasks.length} tasks in #{@testPaths[index]}"
          view.tasks = tasks
          @cwd = @testPaths[index].replace(/\\/g, '/').split('/').slice(0, -1).join('/')
          view.togglePanel() unless atom.config.get('grunt-runner.panelStartsHidden')

    startStopAction: ->
        return @toggleTaskList() if @process == null
        return @stopProcess()

    setStartStopBtn:(isRunning) ->
        if isRunning
            @.startstopbtn.text 'Stop'
            atom.tooltips.add @.startstopbtn,
                title: "",
                keyBindingCommand: 'grunt-runner:stop'
        else
            @.startstopbtn.text 'Start'
            atom.tooltips.add @.startstopbtn,
                title: "",
                keyBindingCommand: 'grunt-runner:run'

    # called to start the process
    # task name is gotten from the input element
    startProcess:(task) ->
        @stopProcess()
        @emptyPanel()
        @status.attr 'data-status', 'loading'

        @addLine "Running : grunt #{task}", 'subtle'

        @.setStartStopBtn true

        @gruntTask task, @path

    # stops the current process if it is running
    stopProcess:(noMessage) ->
        @addLine 'Grunt task was ended', 'warning' if @process and not @process?.killed and not noMessage
        @status.attr 'data-status', null if @process and not @process?.killed and not noMessage
        @process?.kill()
        @process = null
        @.setStartStopBtn false

    # toggles the visibility of the entire panel
    togglePanel: ->
        if @isVisible()
            @detach()
        else
            @attach()
      # return atom.workspace.addBottomPanel(item: this) unless @.isOnDom()
      # return @detach() if @.isOnDom()

    # toggles the visibility of the log
    toggleLog: ->
        @container.toggleClass 'closed'
        if @container.hasClass 'closed'
            @container.parent().height 'auto'
        else
            @container.parent().height '130px'

    # toggles the visibility of the tasklist
    toggleTaskList: ->
        @taskList.toggle(@)

    # runs the most recent task
    runLatestTask: ->
        @taskList.runLatest(@)

    # adds an entry to the log
    # converts all newlines to <br>
    addLine:(text, type = "plain") ->
        [panel, errorList] = [@panel, @errors]
        text = text.replace /\ /g, '&nbsp;'
        text = @colorize text
        text = text.trim().replace /[\r\n]+/g, '<br />'
        if not text.empty
            stuckToBottom = errorList.height() - panel.height() - panel.scrollTop() == 0
            errorList.append "<li class='text-#{type}'>#{text}</li>"
            panel.scrollTop errorList.height() if stuckToBottom

    # clears the log
    emptyPanel: ->
        @errors.empty()

    # bash colors to html
    colorize:(text) ->
        text = text.replace /\[1m(.+?)(\[.+?)/g, '<span class="strong">$1</span>$2'
        text = text.replace /\[4m(.+?)(\[.+?)/g, '<span class="underline">$1</span>$2'
        text = text.replace /\[31m(.+?)(\[.+?)/g, '<span class="red">$1</span>$2'
        text = text.replace /\[32m(.+?)(\[.+?)/g, '<span class="green">$1</span>$2'
        text = text.replace /\[33m(.+?)(\[.+?)/g, '<span class="yellow">$1</span>$2'
        text = text.replace /\[36m(.+?)(\[.+?)/g, '<span class="cyan">$1</span>$2'
        text = text.replace /\[90m(.+?)(\[.+?)/g, '<span class="gray">$1</span>$2'
        text = @stripColorCodes text
        return text

    # remove invalid color codes
    stripColorCodes:(text) ->
        return text.replace /\[[0-9]{1,2}m/g, ''

    # removed color commands
    stripColors:(text) ->
        # borrowed from
        # https://github.com/Filirom1/stripcolorcodes (MIT license)
        return text.replace /\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]/g, ''

    # launches an Atom BufferedProcess
    gruntTask:(task, path) ->
        stdout = (out) ->
            @addLine out
        stderr = (err) ->
            @addLine err, 'error'
        exit = (code) ->
            atom.beep() unless code == 0
            @addLine "Grunt exited: code #{code}.", if code == 0 then 'success' else 'error'
            @status.attr 'data-status', if code == 0 then 'ready' else 'error'
            @stopProcess true

        try
            @process = new BufferedProcess
                command: 'grunt'
                args: [task]
                options: {cwd: @cwd}
                stdout: stdout.bind @
                exit: exit.bind @
        catch e
            # this never gets caught...
            @addLine "Could not find grunt command. Make sure to set the path in the configuration settings." + JSON.stringify(e), "error"
            @stopProcess()

    resizeStarted: =>
        $(document.body).on('mousemove', @resizeGruntRunnerView)
        $(document.body).on('mouseup', @resizeStopped)

    resizeStopped: =>
        $(document.body).off('mousemove', @resizeGruntRunnerView)
        $(document.body).off('mouseup', @resizeStopped)

    resizeGruntRunnerView:(event) =>
        height = $(document.body).height() - event.pageY - $('.status-bar').height()
        @height(height)
