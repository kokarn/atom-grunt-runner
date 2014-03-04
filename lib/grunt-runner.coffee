fs = require 'fs'
grunt = require 'grunt'
{BufferedProcess} = require 'atom'
window.View = require './results-view.coffee'

module.exports =

    path:""
    process:null
    view:null

    # Activates the packages
    # tests for a gruntfile in the project directory
    # if one exists reads it and starts building the menu
    activate:(state) ->
        atom.workspaceView.command 'grunt-runner:stop', @stopProcess.bind @
        atom.workspaceView.command 'grunt-runner:toggle', @toggleView.bind @
        @path = atom.project.getPath()
        @view = new View()

        self = @
        fs.exists self.path + '/Gruntfile.js', (doesExist) ->
            if doesExist
                try # in case of bad syntax
                    require(self.path + '/Gruntfile.js')(grunt)

                # wish there was a less hackier way than _tasks
                self.buildMenu Object.keys grunt.task._tasks if grunt.task._tasks

    # fills the grunt runner menu with the given tasks
    # attaches event listeners to each task
    buildMenu:(tasks) ->
        handler = @handleCommand.bind @
        submenu = tasks.map (value) ->
            command = "grunt-runner:#{value}"
            atom.workspaceView.command command, handler
            {label:"Task: #{value}", command:command}
        .concat [
            {label:''} # temporary seperator
            {label:'Stop Current Task', command:'grunt-runner:stop'}
            {label:'Toggle Grunt Output', command: 'grunt-runner:toggle'}
        ]

        atom.menu.add [
            label: 'Packages'
            submenu: [
                label: 'Grunt'
                submenu: submenu
            ]
        ]

        atom.menu.update()

    # attaches/detaches the view
    toggleView: ->
        return atom.workspaceView.prependToBottom @view unless @view.isOnDom()
        return @view.detach() if @view.isOnDom()


    # kills process if one is running
    stopProcess: ->
        @view.addLine "Grunt task was ended." if @process and not @process.killed
        @process?.kill()
        @process = null

    # handles a menu item being pressed
    # runs a grunt process in the background
    handleCommand:(evt)->

        #stop process if one is running
        @stopProcess()

        taskToRun = evt.type.substring "grunt-runner:".length

        # prepare view
        @view.emptyView().changeTask taskToRun
        @toggleView() unless @view.isOnDom()
        @view.addLine "Running : grunt #{taskToRun}"

        view = @view
        @process = new BufferedProcess
            command: 'grunt'
            options:
                cwd : @path
            args: [taskToRun]
            stdout: (out) ->
                # borrowed from https://github.com/Filirom1/stripcolorcodes (MIT license)
                view.addLine out.replace /\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]/g, ''
            exit: (code) ->
                view.addLine "Grunt exited: code #{code}\n"
                if code != 0
                    atom.beep()
