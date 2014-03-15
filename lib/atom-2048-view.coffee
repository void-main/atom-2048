{View} = require 'atom'

module.exports =
class Atom2048View extends View
  @content: ->
    @div class: 'atom-2048 overlay from-top game-container', =>
      @div class: 'game-message', =>
        @p
        @div class: 'lower', =>
          @a "Keep going", class: 'keep-going-button'
          @a "Try again", class: 'retry-button'
      @div class: 'grid-container', =>
        @div class: 'grid-row', =>
          @div class: 'grid-cell'
          @div class: 'grid-cell'
          @div class: 'grid-cell'
          @div class: 'grid-cell'
        @div class: 'grid-row', =>
          @div class: 'grid-cell'
          @div class: 'grid-cell'
          @div class: 'grid-cell'
          @div class: 'grid-cell'
        @div class: 'grid-row', =>
          @div class: 'grid-cell'
          @div class: 'grid-cell'
          @div class: 'grid-cell'
          @div class: 'grid-cell'
        @div class: 'grid-row', =>
          @div class: 'grid-cell'
          @div class: 'grid-cell'
          @div class: 'grid-cell'
          @div class: 'grid-cell'
      @div class:'tile-container'

  initialize: (serializeState) ->
    atom.workspaceView.command "atom-2048:toggle", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
