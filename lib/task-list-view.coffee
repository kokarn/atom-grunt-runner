{SelectListView, $$} = require 'atom'

module.exports = class TaskListView extends SelectListView

    callback: ->
    items: []

    initialize:(callback, state = {}) ->
        super

        @callback = callback
        @setItems if Array.isArray state.items then state.items else []

        @addClass 'overlay from-top'
        @setMaxItems 5

        _this = @
        this.filterEditorView.on 'keydown', (evt) ->
            if evt.which == 13
                selected = _this.getSelectedItem()
                text = _this.filterEditorView.getEditor().getBuffer().getText()

                _this.confirmed if selected then selected else text

    addItem:(item) ->
        @items = [item].concat @items.filter (value) ->
            item != value

    addItems:(items) ->
        @addItem item for item in items

    confirmed:(item) ->
        @addItem item
        @cancel()
        @callback item

    attach: ->
        @populateList()
        atom.workspaceView.append @
        @focusFilterEditor()

    serialize: ->
        return items: @items.slice 0, 4

    viewForItem:(task) ->
        $$ ->
            @li task

    getEmptyMessage: ->
        "Press Enter to run the task."
