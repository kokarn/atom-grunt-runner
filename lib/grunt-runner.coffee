fs = require 'fs'
window.grunt = require 'grunt'
{BufferedProcess} = require 'atom'

module.exports =

    # Activates the packages
    # tests for a gruntfile in the project directory
    # if one exists reads it and starts building the menu
    activate:(state) ->
        self = @
        self.path = atom.project.getPath()
        fs.exists self.path + '/gruntfile.js', (doesExist) ->
            if doesExist
                try
                    require(self.path + '/gruntfile.js')(grunt)

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
                submenu: tasks.map (value) ->
                    atom.workspaceView.command 'grunt-runner:'+value, self.handleCommand.bind self
                    {label:value, command:'grunt-runner:'+value}
            ]
        ]
        atom.menu.update()

    # handles a menu item being pressed
    # runs a grunt process in the background
    handleCommand:(evt)->
        taskToRun = evt.type.substring 'grunt-runner:'.length

        process = new BufferedProcess
            command: 'grunt'
            options:
                cwd : @path
            args: [taskToRun]
            stdout: (output) ->
                console.log output
            exit: (code) ->
                console.log code
