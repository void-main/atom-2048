{View} = require 'atom'
Tile = (position, value) ->
  @x = position.x
  @y = position.y
  @value = value or 2
  @previousPosition = null
  @mergedFrom = null # Tracks tiles that merged together
  return
Grid = (size) ->
  @size = size
  @cells = []
  @build()
  return

# Build a grid of the specified size

# Find the first available random position

# Call callback for every cell

# Check if there are any cells available

# Check if the specified cell is taken

# Inserts a tile at its position
# Up
# Right
# Down
# Left
# vim keybindings
# W
# D
# S
# A
KeyboardInputManager = ->
  KeyboardInputManager::events = {}
  KeyboardInputManager::listen()
  return

# Listen to swipe events

# (right : left) : (down : up)
HTMLActuator = ->
  @tileContainer = document.querySelector(".tile-container")
  @scoreContainer = document.querySelector(".score-container")
  @bestContainer = document.querySelector(".best-container")
  @messageContainer = document.querySelector(".game-message")
  @score = 0
  return
# You lose
# You win!

# We can't use classlist because it somehow glitches when replacing classes

# Make sure that the tile gets rendered in the previous position first
# Update the position

# Render the tiles that merged

# Add the inner part of the tile to the wrapper

# Put the tile on the board

# IE only takes one value to remove at a time.

# Continues the game (both restart and keep playing)
LocalScoreManager = ->
  @key = "bestScore"
  supported = @localStorageSupported()
  @storage = (if supported then window.localStorage else window.fakeStorage)
  return
GameManager = (size, InputManager, Actuator, ScoreManager) ->
  @size = size # Size of the grid
  @inputManager = new InputManager
  @scoreManager = new ScoreManager
  @actuator = new Actuator
  @startTiles = 2
  @inputManager.on "move", @move.bind(this)
  @inputManager.on "restart", @restart.bind(this)
  @inputManager.on "keepPlaying", @keepPlaying.bind(this)
  @setup()
  return
(->
  lastTime = 0
  vendors = [
    "webkit"
    "moz"
  ]
  x = 0

  while x < vendors.length and not window.requestAnimationFrame
    window.requestAnimationFrame = window[vendors[x] + "RequestAnimationFrame"]
    window.cancelAnimationFrame = window[vendors[x] + "CancelAnimationFrame"] or window[vendors[x] + "CancelRequestAnimationFrame"]
    ++x
  unless window.requestAnimationFrame
    window.requestAnimationFrame = (callback, element) ->
      currTime = new Date().getTime()
      timeToCall = Math.max(0, 16 - (currTime - lastTime))
      id = window.setTimeout(->
        callback currTime + timeToCall
        return
      , timeToCall)
      lastTime = currTime + timeToCall
      id
  unless window.cancelAnimationFrame
    window.cancelAnimationFrame = (id) ->
      clearTimeout id
      return
  return
)()
Tile::savePosition = ->
  @previousPosition =
    x: @x
    y: @y

  return

Tile::updatePosition = (position) ->
  @x = position.x
  @y = position.y
  return

Grid::build = ->
  x = 0

  while x < @size
    row = @cells[x] = []
    y = 0

    while y < @size
      row.push null
      y++
    x++
  return

Grid::randomAvailableCell = ->
  cells = @availableCells()
  cells[Math.floor(Math.random() * cells.length)]  if cells.length

Grid::availableCells = ->
  cells = []
  @eachCell (x, y, tile) ->
    unless tile
      cells.push
        x: x
        y: y

    return

  cells

Grid::eachCell = (callback) ->
  x = 0

  while x < @size
    y = 0

    while y < @size
      callback x, y, @cells[x][y]
      y++
    x++
  return

Grid::cellsAvailable = ->
  !!@availableCells().length

Grid::cellAvailable = (cell) ->
  not @cellOccupied(cell)

Grid::cellOccupied = (cell) ->
  !!@cellContent(cell)

Grid::cellContent = (cell) ->
  if @withinBounds(cell)
    @cells[cell.x][cell.y]
  else
    null

Grid::insertTile = (tile) ->
  @cells[tile.x][tile.y] = tile
  return

Grid::removeTile = (tile) ->
  @cells[tile.x][tile.y] = null
  return

Grid::withinBounds = (position) ->
  position.x >= 0 and position.x < @size and position.y >= 0 and position.y < @size

keymap =
  75: 0
  76: 1
  74: 2
  72: 3
  87: 0
  68: 1
  83: 2
  65: 3

KeyboardInputManager::on = (event, callback) ->
  KeyboardInputManager::events[event] = []  unless KeyboardInputManager::events[event]
  KeyboardInputManager::events[event].push callback
  return

KeyboardInputManager::emit = (event, data) ->
  callbacks = @events[event]
  if callbacks
    callbacks.forEach (callback) ->
      callback data
      return

  return

listenerFunc = (event) ->
  KeyboardInputManager::listener event
  return

KeyboardInputManager::listener = (event) ->
  modifiers = event.altKey or event.ctrlKey or event.metaKey or event.shiftKey
  mapped = keymap[event.which]
  unless modifiers
    event.preventDefault() unless event.which is 66 # b key for boss
    if mapped isnt `undefined`
      @emit "move", mapped
    @restart.bind(this) event  if event.which is 32

  return

KeyboardInputManager::listen = ->
  self = this
  console.log(this)
  document.addEventListener "keydown", listenerFunc
  retry = document.querySelector(".retry-button")
  retry.addEventListener "click", @restart.bind(this)
  retry.addEventListener "touchend", @restart.bind(this)
  keepPlaying = document.querySelector(".keep-playing-button")
  keepPlaying.addEventListener "click", @keepPlaying.bind(this)
  keepPlaying.addEventListener "touchend", @keepPlaying.bind(this)
  touchStartClientX = undefined
  touchStartClientY = undefined
  gameContainer = document.getElementsByClassName("game-container")[0]
  gameContainer.addEventListener "touchstart", (event) ->
    return  if event.touches.length > 1
    touchStartClientX = event.touches[0].clientX
    touchStartClientY = event.touches[0].clientY
    event.preventDefault()
    return

  gameContainer.addEventListener "touchmove", (event) ->
    event.preventDefault()
    return

  gameContainer.addEventListener "touchend", (event) ->
    return  if event.touches.length > 0
    dx = event.changedTouches[0].clientX - touchStartClientX
    absDx = Math.abs(dx)
    dy = event.changedTouches[0].clientY - touchStartClientY
    absDy = Math.abs(dy)
    self.emit "move", (if absDx > absDy then ((if dx > 0 then 1 else 3)) else ((if dy > 0 then 2 else 0)))  if Math.max(absDx, absDy) > 10
    return

  return

KeyboardInputManager::stopListen = ->
  document.removeEventListener "keydown", listenerFunc
  return

KeyboardInputManager::restart = (event) ->
  event.preventDefault()
  @emit "restart"
  return

KeyboardInputManager::keepPlaying = (event) ->
  event.preventDefault()
  @emit "keepPlaying"
  return

HTMLActuator::actuate = (grid, metadata) ->
  self = this
  window.requestAnimationFrame ->
    self.clearContainer self.tileContainer
    grid.cells.forEach (column) ->
      column.forEach (cell) ->
        self.addTile cell  if cell
        return

      return

    self.updateScore metadata.score
    self.updateBestScore metadata.bestScore
    if metadata.terminated
      if metadata.over
        self.message false
      else self.message true  if metadata.won
    return

  return

HTMLActuator::clearContainer = (container) ->
  if container
    container.removeChild container.firstChild  while container.firstChild
  return

HTMLActuator::addTile = (tile) ->
  self = this
  wrapper = document.createElement("div")
  inner = document.createElement("div")
  position = tile.previousPosition or
    x: tile.x
    y: tile.y

  positionClass = @positionClass(position)
  classes = [
    "tile"
    "tile-" + tile.value
    positionClass
  ]
  classes.push "tile-super"  if tile.value > 2048
  @applyClasses wrapper, classes
  inner.classList.add "tile-inner"
  inner.textContent = tile.value
  if tile.previousPosition
    window.requestAnimationFrame ->
      classes[2] = self.positionClass(
        x: tile.x
        y: tile.y
      )
      self.applyClasses wrapper, classes
      return

  else if tile.mergedFrom
    classes.push "tile-merged"
    @applyClasses wrapper, classes
    tile.mergedFrom.forEach (merged) ->
      self.addTile merged
      return

  else
    classes.push "tile-new"
    @applyClasses wrapper, classes
  wrapper.appendChild inner
  @tileContainer.appendChild wrapper
  return

HTMLActuator::applyClasses = (element, classes) ->
  element.setAttribute "class", classes.join(" ")
  return

HTMLActuator::normalizePosition = (position) ->
  x: position.x + 1
  y: position.y + 1

HTMLActuator::positionClass = (position) ->
  position = @normalizePosition(position)
  "tile-position-" + position.x + "-" + position.y

HTMLActuator::updateScore = (score) ->
  @clearContainer @scoreContainer
  difference = score - @score
  @score = score
  @scoreContainer.textContent = @score
  if difference > 0
    addition = document.createElement("div")
    addition.classList.add "score-addition"
    addition.textContent = "+" + difference
    @scoreContainer.appendChild addition
  return

HTMLActuator::updateBestScore = (bestScore) ->
  @bestContainer.textContent = bestScore
  return

HTMLActuator::message = (won) ->
  type = (if won then "game-won" else "game-over")
  message = (if won then "You win!" else "Game over!")
  @messageContainer.classList.add type
  @messageContainer.getElementsByTagName("p")[0].textContent = message
  return

HTMLActuator::clearMessage = ->
  @messageContainer.classList.remove "game-won"
  @messageContainer.classList.remove "game-over"
  return

HTMLActuator::continueKeep = ->
  @clearMessage()
  return

window.fakeStorage =
  _data: {}
  setItem: (id, val) ->
    @_data[id] = String(val)

  getItem: (id) ->
    (if @_data.hasOwnProperty(id) then @_data[id] else `undefined`)

  removeItem: (id) ->
    delete @_data[id]

  clear: ->
    @_data = {}

LocalScoreManager::localStorageSupported = ->
  testKey = "test"
  storage = window.localStorage
  try
    storage.setItem testKey, "1"
    storage.removeItem testKey
    return true
  catch error
    return false
  return

LocalScoreManager::get = ->
  @storage.getItem(@key) or 0

LocalScoreManager::set = (score) ->
  @storage.setItem @key, score
  return


# Restart the game
GameManager::restart = ->
  @actuator.continueKeep()
  @setup()
  return


# Keep playing after winning
GameManager::keepPlaying = ->
  @keepPlaying = true
  @actuator.continueKeep()
  return

GameManager::isGameTerminated = ->
  if @over or (@won and not @keepPlaying)
    true
  else
    false


# Set up the game
GameManager::setup = ->
  @grid = new Grid(@size)
  @score = 0
  @over = false
  @won = false
  @keepPlaying = false

  # Add the initial tiles
  @addStartTiles()

  # Update the actuator
  @actuate()
  return


# Set up the initial tiles to start the game with
GameManager::addStartTiles = ->
  i = 0

  while i < @startTiles
    @addRandomTile()
    i++
  return


# Adds a tile in a random position
GameManager::addRandomTile = ->
  if @grid.cellsAvailable()
    value = (if Math.random() < 0.9 then 2 else 4)
    tile = new Tile(@grid.randomAvailableCell(), value)
    @grid.insertTile tile
  return


# Sends the updated grid to the actuator
GameManager::actuate = ->
  @scoreManager.set @score  if @scoreManager.get() < @score
  @actuator.actuate @grid,
    score: @score
    over: @over
    won: @won
    bestScore: @scoreManager.get()
    terminated: @isGameTerminated()

  return


# Save all tile positions and remove merger info
GameManager::prepareTiles = ->
  @grid.eachCell (x, y, tile) ->
    if tile
      tile.mergedFrom = null
      tile.savePosition()
    return

  return


# Move a tile and its representation
GameManager::moveTile = (tile, cell) ->
  @grid.cells[tile.x][tile.y] = null
  @grid.cells[cell.x][cell.y] = tile
  tile.updatePosition cell
  return


# Move tiles on the grid in the specified direction
GameManager::move = (direction) ->

  # 0: up, 1: right, 2:down, 3: left
  self = this
  return  if @isGameTerminated() # Don't do anything if the game's over
  cell = undefined
  tile = undefined
  vector = @getVector(direction)
  traversals = @buildTraversals(vector)
  moved = false

  # Save the current tile positions and remove merger information
  @prepareTiles()

  # Traverse the grid in the right direction and move tiles
  traversals.x.forEach (x) ->
    traversals.y.forEach (y) ->
      cell =
        x: x
        y: y

      tile = self.grid.cellContent(cell)
      if tile
        positions = self.findFarthestPosition(cell, vector)
        next = self.grid.cellContent(positions.next)

        # Only one merger per row traversal?
        if next and next.value is tile.value and not next.mergedFrom
          merged = new Tile(positions.next, tile.value * 2)
          merged.mergedFrom = [
            tile
            next
          ]
          self.grid.insertTile merged
          self.grid.removeTile tile

          # Converge the two tiles' positions
          tile.updatePosition positions.next

          # Update the score
          self.score += merged.value

          # The mighty 2048 tile
          self.won = true  if merged.value is 2048
        else
          self.moveTile tile, positions.farthest
        moved = true  unless self.positionsEqual(cell, tile) # The tile moved from its original cell!
      return

    return

  if moved
    @addRandomTile()
    @over = true  unless @movesAvailable() # Game over!
    @actuate()
  return


# Get the vector representing the chosen direction
GameManager::getVector = (direction) ->

  # Vectors representing tile movement
  map =
    0: # up
      x: 0
      y: -1

    1: # right
      x: 1
      y: 0

    2: # down
      x: 0
      y: 1

    3: # left
      x: -1
      y: 0

  map[direction]


# Build a list of positions to traverse in the right order
GameManager::buildTraversals = (vector) ->
  traversals =
    x: []
    y: []

  pos = 0

  while pos < @size
    traversals.x.push pos
    traversals.y.push pos
    pos++

  # Always traverse from the farthest cell in the chosen direction
  traversals.x = traversals.x.reverse()  if vector.x is 1
  traversals.y = traversals.y.reverse()  if vector.y is 1
  traversals

GameManager::findFarthestPosition = (cell, vector) ->
  previous = undefined

  # Progress towards the vector direction until an obstacle is found
  loop
    previous = cell
    cell =
      x: previous.x + vector.x
      y: previous.y + vector.y
    break unless @grid.withinBounds(cell) and @grid.cellAvailable(cell)
  farthest: previous
  next: cell # Used to check if a merge is required

GameManager::movesAvailable = ->
  @grid.cellsAvailable() or @tileMatchesAvailable()


# Check for available matches between tiles (more expensive check)
GameManager::tileMatchesAvailable = ->
  self = this
  tile = undefined
  x = 0

  while x < @size
    y = 0

    while y < @size
      tile = @grid.cellContent(
        x: x
        y: y
      )
      if tile
        direction = 0

        while direction < 4
          vector = self.getVector(direction)
          cell =
            x: x + vector.x
            y: y + vector.y

          other = self.grid.cellContent(cell)
          return true  if other and other.value is tile.value # These two tiles can be merged
          direction++
      y++
    x++
  false

GameManager::positionsEqual = (first, second) ->
  first.x is second.x and first.y is second.y

module.exports =
class Atom2048View extends View
  @bossMode = false

  @content: ->
    @div class: 'atom-2048 overlay from-top', =>
      @div class: 'container', =>
        @div class: 'heading', =>
          @h1 "2048", class: 'title', =>
          @div class: 'scores-container', =>
            @div 0, class: 'score-container'
            @div 0, class: 'best-container'
        @div class: 'game-container', =>
          @div class: 'game-message', =>
            @p " "
            @div class: 'lower', =>
              @a "Keep going", class: 'keep-playing-button'
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
    @bossMode = false
    atom.workspaceView.command "atom-2048:toggle", => @toggle()

    atom.workspaceView.command "atom-2048:bossComing", (e) =>
      if @hasParent()
        @bossComing()
      else
        e.abortKeyBinding()

    atom.workspaceView.command "atom-2048:bossAway", => @bossAway()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  bossComing: ->
    KeyboardInputManager::stopListen()
    @bossMode = true
    @detach()

  bossAway: ->
    if @bossMode
      atom.workspaceView.append(this)
      KeyboardInputManager::listen()

  toggle: ->
    if @hasParent()
      KeyboardInputManager::stopListen()
      @detach()
    else
      window.requestAnimationFrame ->
        new GameManager(4, KeyboardInputManager, HTMLActuator, LocalScoreManager)
      atom.workspaceView.append(this)
