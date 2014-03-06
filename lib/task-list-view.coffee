{SelectListView, $$} = require 'atom'

module.exports = class TaskListView extends SelectListView

    initialize:(callback) ->
        super


        _this = @
        this.filterEditorView.on 'keydown', (evt) ->
            _this.confirmText this.value if evt.which == 13

        @callback = callback
        @addClass 'overlay from-top'
        @setMaxItems 5

    confirmed:(item) ->
        console.log item
        @callback item

    confirmText:(text) ->
        @confirmed text

    attach: ->
        @populateList()
        atom.workspaceView.append @
        @focusFilterEditor()

    viewForItem:(task) ->
        $$ ->
            @li task
