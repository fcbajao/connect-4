_ = require("underscore")
GameState = require("game_state")

MINIMAX_DEPTH = 5

class Player
  constructor: (@name, @bot = false) ->
    @latestBestMove = null

  requestMove: (game, depth = MINIMAX_DEPTH) ->
    currentState = game.currentState

    [me, opponent] = if game.player1 is this
      [game.player1, game.player2]
    else
      [game.player2, game.player1]

    _minimax.call(this, currentState, me, me, opponent, depth)
    @latestBestMove
    
  _minimax = (state, currentPlayer, me, opponent, depth) ->
    if depth is 0 or (state.isOver())
      return _score.call(this, state, me, opponent)

    maxScore = if currentPlayer is me
      isMaximizing = true
      -9999
    else
      isMaximizing = false
      9999

    bestMove = {x: null, score: maxScore}

    moves = state.getAvailableMoves()
    nextPlayer = if currentPlayer is me
      opponent
    else
      me

    for x in moves
      newState = new GameState(state)
      newState.makeMove(x, currentPlayer)
      score = _minimax.call(this, newState, nextPlayer, me, opponent, depth - 1)

      if (isMaximizing and score > bestMove.score) or (not isMaximizing and score < bestMove.score)
        bestMove.x = x
        bestMove.score = score

    @latestBestMove = bestMove.x
    bestMove.score

  _score = (state, me, opponent) ->
    if state.getWinner() is me
      10
    else if state.getWinner() is opponent
      -10
    else
      0

module.exports = Player
