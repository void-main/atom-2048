{View} = require 'atom'

module.exports =
class Atom2048View extends View
  @content: ->
    @div class: 'atom-2048 overlay from-top game-container', =>
      @div class: 'atom-2048 game-message', =>
        @p "This is p element!"
        @div class: 'atom-2048 lower', =>
          @a "Keep going", class: 'atom-2048 keep-going-button'
          @a "Try again", class: 'atom-2048 retry-button'
      @div class: 'atom-2048 grid-container', =>
        @div class: 'atom-2048 grid-row', =>
          @div class: 'atom-2048 grid-cell'
          @div class: 'atom-2048 grid-cell'
          @div class: 'atom-2048 grid-cell'
          @div class: 'atom-2048 grid-cell'
        @div class: 'atom-2048 grid-row', =>
          @div class: 'atom-2048 grid-cell'
          @div class: 'atom-2048 grid-cell'
          @div class: 'atom-2048 grid-cell'
          @div class: 'atom-2048 grid-cell'
        @div class: 'atom-2048 grid-row', =>
          @div class: 'atom-2048 grid-cell'
          @div class: 'atom-2048 grid-cell'
          @div class: 'atom-2048 grid-cell'
          @div class: 'atom-2048 grid-cell'
        @div class: 'atom-2048 grid-row', =>
          @div class: 'atom-2048 grid-cell'
          @div class: 'atom-2048 grid-cell'
          @div class: 'atom-2048 grid-cell'
          @div class: 'atom-2048 grid-cell'
      @div class:'atom-2048 tile-container'

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
