{View} = require 'atom'

module.exports =
class Atom2048View extends View
  @content: ->
    @div class: 'atom-2048 overlay from-top', =>
      @div "The Atom2048 package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "atom-2048:toggle", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log "Atom2048View was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
