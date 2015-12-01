Atom2048View = require './atom-2048-view'

module.exports = Atom2048 =
  atom2048View: null

  config:
    'Enable Power Mode':
      type: 'boolean'
      default: false
    'Power Level':
      type: 'integer'
      default: 5
      minimum: 1
      maximum: 20

  activate: (state) ->
    @atom2048View = new Atom2048View(state.atom2048ViewState)

  deactivate: ->
    @atom2048View.destroy()

  serialize: ->
    atom2048ViewState: @atom2048View.serialize()
