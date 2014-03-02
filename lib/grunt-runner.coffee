Proxy = require './grunt-proxy'
fs = require('fs')

module.exports =
    gruntRunnerView: null

    activate:(state) ->
        path = atom.project.getPath()
        fs.exists path + '/gruntfile.js', (doesExist) ->
            if doesExist
                window.proxy = new Proxy()
                require(path + '/gruntfile.js')(proxy)
                atom.menu.add [
                    label: 'Packages'
                    submenu: [
                        label: 'Grunt'
                        submenu: proxy.tasks.map (value) ->
                            atom.workspaceView.command 'grunt-runner:'+value, ->
                                console.log("HI")
                            {label:value, command:'grunt-runner:'+value}
                    ]
                ]

                atom.menu.update()
