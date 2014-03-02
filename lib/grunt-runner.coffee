fs = require 'fs'
window.grunt = require 'grunt'

module.exports =
    path: ""
    activate:(state) ->
        self = @
        self.path = atom.project.getPath()
        fs.exists self.path + '/gruntfile.js', (doesExist) ->
            if doesExist
                require(self.path + '/gruntfile.js')(grunt)
                self.buildMenu Object.keys grunt.task._tasks if grunt.task._tasks

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

    handleCommand:(evt)->
        task = evt.type.substring 'grunt-runner:'.length
        grunt.tasks task, {gruntfile: @path + '/gruntfile.js'}, ()->
            console.log arguments
