{View} = require 'atom-space-pen-views'

module.exports =
class AchievementsView extends View
  @content: ->
      @div tabindex: -1, class: 'achievements overlay from-top', =>
        @img class: "inline-block", src: "http://gabrielecirulli.github.io/2048/meta/apple-touch-icon.png", width: '32px', height: '32px', outlet: "icon"
        @div class: "achievements-message-body inline-block", =>
          @div class: "block-tight text-smaller text-highlight", "You could have earned a new achievement!"
          @div class: "block-tight text-smaller", "Install achievements package in atom to unlock achievement system"

  initialize: (serializeState) ->

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  # destroy + this
  cleanup: =>
    @destroy()

  achieve: ->
    atom.workspaceView.append(this)
    setTimeout(@cleanup, 5000)
