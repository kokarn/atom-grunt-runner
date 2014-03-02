GruntRunnerView = require './grunt-runner-view'

module.exports =
  gruntRunnerView: null

  activate: (state) ->
    @gruntRunnerView = new GruntRunnerView(state.gruntRunnerViewState)

  deactivate: ->
    @gruntRunnerView.destroy()

  serialize: ->
    gruntRunnerViewState: @gruntRunnerView.serialize()
