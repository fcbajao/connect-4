$ = require("jquery")
_ = require("underscore")
GameState = require("game_state")

GRID_WIDTH = 7
GRID_HEIGHT = 6

class Game
  constructor: (@player1, @player2, @board, @options = {}) ->
    _renderSlots.call(this, @board)
    _setupBoardEventHandlers.call(this, @board)
    _enableBoard.call(this, @board)
    @currentState = new GameState
    @onTurnStart(@getCurrentTurn())

  destroy: ->
    _disableBoard.call(this, @board)
    _teardownBoardEventHandlers.call(this, @board)

  getCurrentTurn: ->
    @activePlayer ?= @player1

  makeMove: (x, player) ->
    @currentState.makeMove(x, player)
    lastMove = @currentState.getLastMove()
    elem = _getSlotElem.call(this, lastMove.x, lastMove.y)

    playerClass = if player is @player1
      "player-1"
    else
      "player-2"

    elem.addClass(playerClass)

    winner = @currentState.getWinner()

    if winner is player
      @onVictory(player)
    else if @currentState.getAvailableMoves().length is 0
      @onDraw()
    else
      nextPlayer = _.without([@player1, @player2], player)[0]
      @onTurnStart(nextPlayer)

  onTurnStart: (nextPlayer) ->
    @activePlayer = nextPlayer
    @options.onTurnStart(nextPlayer) if @options.onTurnStart?

    if nextPlayer.bot
      x = nextPlayer.requestMove(this)
      @makeMove(x, nextPlayer)

  onVictory: (victor) ->
    @options.onVictory(victor) if @options.onVictory?

  onDraw: ->
    @options.onDraw() if @options.onDraw?

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
    x = slot.data("x")
    activePlayer = @getCurrentTurn()
    return if activePlayer.bot or @currentState.isOver() or x not in @currentState.getAvailableMoves()
    @makeMove(x, activePlayer)

  _getSlotElem = (x, y) ->
    @board.find(".slot[data-x=#{x}][data-y=#{y}]")

module.exports = Game
