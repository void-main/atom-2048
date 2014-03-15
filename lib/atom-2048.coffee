Atom2048View = require './atom-2048-view'

module.exports =
  atom2048View: null

  activate: (state) ->
    @atom2048View = new Atom2048View(state.atom2048ViewState)

  deactivate: ->
    @atom2048View.destroy()

  serialize: ->
    atom2048ViewState: @atom2048View.serialize()
