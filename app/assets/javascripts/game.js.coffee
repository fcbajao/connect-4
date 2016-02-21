$ = require("jquery")
_ = require("underscore")

GRID_WIDTH = 7
GRID_HEIGHT = 6
NEUTRAL_DIRECTION = 0
UP_DIRECTION = +1
RIGHT_DIRECTION = +1
DOWN_DIRECTION = -1
LEFT_DIRECTION = -1


class Game
  constructor: (@player1, @player2, @board, @options = {}) ->
    @grid = [[], [], [], [], [], [], []]
    _renderSlots.call(this, @board)
    _setupBoardEventHandlers.call(this, @board)
    @onTurnStart(@getActivePlayer())
    _enableBoard.call(this, @board)

  destroy: ->
    _disableBoard.call(this, @board)
    _teardownBoardEventHandlers.call(this, @board)

  getActivePlayer: ->
    @activePlayer ?= @player1

  placeChip: (x, player) ->
    return if @victor? or @grid[x].length is GRID_HEIGHT
    y = @grid[x].length

    elem = _getSlotElem.call(this, x, y)

    playerClass = if player is @player1
      "player-1"
    else
      "player-2"

    elem.addClass(playerClass)
    @grid[x][y] = player

    @determineTurnResult(x, y)

  determineTurnResult: (latestX, latestY) ->
    player = @grid[latestX][latestY]

    diagonalBackward = _getDiagonalBackwardConnection.call(this, latestX, latestY)
    if diagonalBackward.length >= 4
      return @onVictory(player)

    diagonalForward = _getDiagonalForwardConnection.call(this, latestX, latestY)
    if diagonalForward.length >= 4
      return @onVictory(player)

    horizontal = _getHorizontalConnection.call(this, latestX, latestY)
    if horizontal.length >= 4
      return @onVictory(player)

    vertical = _getVerticalConnection.call(this, latestX, latestY)
    if vertical.length >= 4
      return @onVictory(player)

    nextPlayer = _.without([@player1, @player2], player)[0]
    @onTurnStart(nextPlayer)

  onTurnStart: (nextPlayer) ->
    @activePlayer = nextPlayer
    @options.onTurnStart(nextPlayer) if @options.onTurnStart?

  onVictory: (victor) ->
    @victor = victor
    @options.onVictory(victor) if @options.onVictory?

  _enableBoard = (board) ->
    board.addClass("enabled")

  _disableBoard = (board) ->
    board.removeClass("enabled")

  _renderSlots = (board) ->
    html = ""
    x = 0
    y = GRID_HEIGHT - 1

    _.times (GRID_WIDTH * GRID_HEIGHT), ->
      html += _slotHTML.call(this, x, y)
      if x is (GRID_WIDTH - 1)
        x = 0
        y -= 1
      else
        x += 1

    board.html(html)

  _slotHTML = (x, y) ->
    "<div class='slot' data-x='#{x}' data-y='#{y}'></div>"

  _setupBoardEventHandlers = (board) ->
    board.on "click", ".slot", _onBoardClick.bind(this)

  _teardownBoardEventHandlers = (board) ->
    board.off "click", ".slot"

  _onBoardClick = (e) ->
    slot = $(e.target)
    @placeChip(slot.data("x"), @getActivePlayer())

  _getSlotElem = (x, y) ->
    @board.find(".slot[data-x=#{x}][data-y=#{y}]")

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

module.exports = Game
