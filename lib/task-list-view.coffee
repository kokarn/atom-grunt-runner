###
Nicholas Clawson -2014

Popup list view to select tasks to run.
Extends Atoms SelectListView but adds the functionality
of being able to add custom tasks to the list
###

{$, $$, SelectListView, View} = require 'atom-space-pen-views'

module.exports = class TaskListView extends SelectListView
    runner: ->
    activate: ->
        new TaskListView

    # creates the view, handles previous state
    initialize:(serializeState) ->
        super
        @addClass('grunt-runner')

    cancelled: ->
        @hide()

    # called when an Item is selected
    confirmed:(item) ->
        @latestItem = item
        @runner.startProcess item
        @cancel()

    toggle: (runner) ->
        @runner = runner
        if @panel?.isVisible()
            @hide()
        else
            @show()

    hide: ->
        @panel?.hide()

    show: ->
        @panel ?= atom.workspace.addModalPanel(item: this)
        @panel.show()

        items = @runner.tasks
        @setItems if Array.isArray items then items else []

        @focusFilterEditor()

    # uses jquery(?) to return an object
    viewForItem:(task) ->
        $$ ->
            @li class: 'two-lines', 'data-projects-title': task, =>
                @div class: 'primary-line', =>
                    @div =>
                        @span task

    # run the latest task
    runLatest:(runner) ->
        if @latestItem
            runner.startProcess @latestItem
        else
            @toggle runner

    # my empty message
    getEmptyMessage: ->
        "Press Enter to run the task."
