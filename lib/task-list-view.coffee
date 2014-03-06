{SelectListView, $$} = require 'atom'

module.exports = class TaskListView extends SelectListView

    initialize:(callback) ->
        super

        @items = []
        @callback = callback
        @addClass 'overlay from-top'
        @setMaxItems 5

        _this = window.test = @
        this.filterEditorView.on 'keydown', (evt) ->
            text = _this.filterEditorView.getEditor().getBuffer().getText()
            _this.confirmed text if evt.which == 13 and text != ""

    confirmed:(item) ->
        @items = [item].concat @items.filter (value) ->
            item != value
        @cancel()
        @callback item

    attach: ->
        @populateList()
        atom.workspaceView.append @
        @focusFilterEditor()

    destroy: ->
        @detach()

    viewForItem:(task) ->
        $$ ->
            @li task

    getEmptyMessage: ->
        "Press Enter to run the task."
