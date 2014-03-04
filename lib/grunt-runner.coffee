fs = require 'fs'
grunt = require 'grunt'
{BufferedProcess} = require 'atom'
window.View = require './results-view.coffee'

module.exports =

    path:""
    process:null
    view: null

    # Activates the packages
    # tests for a gruntfile in the project directory
    # if one exists reads it and starts building the menu
    activate:(state) ->
        atom.workspaceView.command 'grunt-runner:stop', @stopProcess.bind @

        self = @
        self.path = atom.project.getPath()
        fs.exists self.path + '/Gruntfile.js', (doesExist) ->
            if doesExist
                try
                    require(self.path + '/Gruntfile.js')(grunt)

                # wish there was a less hackier way than _tasks
                self.buildMenu Object.keys grunt.task._tasks if grunt.task._tasks

    # fills the grunt runner menu with the given tasks
    # attaches event listeners to each task
    # TODO add refresh once Atom supports removing menu items
    buildMenu:(tasks) ->
        self = @
        atom.menu.add [
            label: 'Packages'
            submenu: [
                label: 'Grunt'
                submenu: [
                    {label:'Stop Current Task', command:'grunt-runner:stop'}
                    ].concat tasks.map (value) ->
                    atom.workspaceView.command 'grunt-runner:'+value, self.handleCommand.bind self
                    {label:'Task: ' + value, command:'grunt-runner:'+value}
            ]
        ]
        atom.menu.update()

    # kills process if one is running
    stopProcess: ->
        @process?.kill()
        @process = null
        @view?.addLine "Grunt task was ended."

    # handles a menu item being pressed
    # runs a grunt process in the background
    handleCommand:(evt)->

        #stop process if one is running
        @stopProcess()

        taskToRun = evt.type.substring 'grunt-runner:'.length
        output = ""

        # clear view

        # make new view
        @view = view = @view?.changeTask(taskToRun) or new View
            task : taskToRun

        @view.emptyView()
        atom.workspaceView.prependToBottom @view

        view.addLine "Running : grunt #{taskToRun}"

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
