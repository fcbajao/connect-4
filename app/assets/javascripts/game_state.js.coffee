_ = require("underscore")

GRID_WIDTH = 7
GRID_HEIGHT = 6
NEUTRAL_DIRECTION = 0
UP_DIRECTION = +1
RIGHT_DIRECTION = +1
DOWN_DIRECTION = -1
LEFT_DIRECTION = -1

class GameState
  constructor: (previousState = null) ->
    @grid = [[], [], [], [], [], [], []]

    if previousState?
      @lastMove = _.clone(previousState.lastMove)
      for rows, x in previousState.grid
        for player, y in rows
          @grid[x][y] = player

  makeMove: (x, player) ->
    y = @grid[x].length

    @grid[x][y] = player
    @lastMove = {x: x, y: y, player: player}

    @checkWinner(x, y)

  checkWinner: (x, y) ->
    player = @grid[x][y]

    diagonalBackward = _getDiagonalBackwardConnection.call(this, x, y)
    if diagonalBackward.length >= 4
      @winner = player
      return

    diagonalForward = _getDiagonalForwardConnection.call(this, x, y)
    if diagonalForward.length >= 4
      @winner = player
      return

    horizontal = _getHorizontalConnection.call(this, x, y)
    if horizontal.length >= 4
      @winner = player
      return

    vertical = _getVerticalConnection.call(this, x, y)
    if vertical.length >= 4
      @winner = player
      return

  getAvailableMoves: ->
    slots = []
    for rows, col in @grid
      slots.push(col) unless rows.length is GRID_HEIGHT
    slots

  getLastMove: ->
    @lastMove

  getWinner: ->
    @winner

  isOver: ->
    @getWinner()? or @getAvailableMoves().length is 0

  _getDiagonalBackwardConnection = (x, y) ->
    connection = [[x, y]]
    # Start search downwards
    connection = connection.concat _collectConnectedCoordinates.call(this, x, y, LEFT_DIRECTION, DOWN_DIRECTION)
    # Start search upwards
    connection = connection.concat _collectConnectedCoordinates.call(this, x, y, RIGHT_DIRECTION, UP_DIRECTION)
    connection

  _getDiagonalForwardConnection = (x, y) ->
    connection = [[x, y]]
    # Start search downwards
    connection = connection.concat _collectConnectedCoordinates.call(this, x, y, RIGHT_DIRECTION, DOWN_DIRECTION)
    # Start search upwards
    connection = connection.concat _collectConnectedCoordinates.call(this, x, y, LEFT_DIRECTION, UP_DIRECTION)
    connection

  _getHorizontalConnection = (x, y) ->
    connection = [[x, y]]
    # Start search left
    connection = connection.concat _collectConnectedCoordinates.call(this, x, y, LEFT_DIRECTION, NEUTRAL_DIRECTION)
    # Start search right
    connection = connection.concat _collectConnectedCoordinates.call(this, x, y, RIGHT_DIRECTION, NEUTRAL_DIRECTION)
    connection

  _getVerticalConnection = (x, y) ->
    connection = [[x, y]]
    # Start search downward
    connection = connection.concat _collectConnectedCoordinates.call(this, x, y, NEUTRAL_DIRECTION, DOWN_DIRECTION)
    connection

  _collectConnectedCoordinates = (x, y, xDirection, yDirection) ->
    player = @grid[x][y]
    connection = []

    x2 = x
    y2 = y
    searching = true
    while searching
      x2 = x2 + xDirection
      y2 = y2 + yDirection

      candidate = @grid[x2]?[y2]
      if candidate? and candidate is player
        connection.push([x2, y2])
      else
        searching = false

    connection

module.exports = GameState
