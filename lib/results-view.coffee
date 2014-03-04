{View} = require 'atom'

module.exports = class ResultsView extends View

    #outlets:
    #    title
    #    panel
    #    errorList

    @content: ->
        @div class: 'grunt-runner-results tool-panel panel-bottom', =>
            @div class: 'panel-heading-affix padded', =>
                @span 'grunt-runner : '
                @span outlet:'title', "no task"
            @div outlet:'panel', class: 'panel-body padded', =>
                @ul outlet:'errorList', class: 'list-group'

    changeTask: (task) ->
        @title.text task
        return @

    emptyView: ->
        @errorList.empty()
        return @

    addLine:(text, type = "plain") ->
        [panel, errorList] = [@panel, @errorList]

        text.split("\n").forEach (value)->
            stuckToBottom = errorList.height() - panel.height() - panel.scrollTop() == 0
            errorList.append "<li class='grunt-format-#{type}'>#{value}</li>"
            panel.scrollTop errorList.height() if stuckToBottom

        return @
