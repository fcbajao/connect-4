$ = require("jquery")
Game = require("game")
Player = require("player")

form = null
board = null
notice = null
game = null

_setupElements = ->
  form = $(".new-game-form")
  board = $(".board")
  notice = $(".notice")

_setupEvents = ->
  form.on "submit", (e) ->
    e.preventDefault()

    player1 = $.trim form.find("#first_player_name").val()
    player2 = $.trim form.find("#second_player_name").val()

    if player1 is "" and player2 is ""
      alert("There must be one human player.")
      return

    player1 = if player1 isnt ""
      new Player(player1)
    else
      new Player("Bot 1", true)

    player2 = if player2 isnt ""
      new Player(player2)
    else
      new Player("Bot 2", true)

    game.destroy() if game?
    game = new Game(player1, player2, board, onTurnStart: _onTurnStart, onVictory: _onVictory, onDraw: _onDraw)

_onTurnStart = (player) ->
  notice.text("It's #{player.name}'s turn.")

_onVictory = (player) ->
  notice.text("#{player.name} Wins!")

_onDraw = ->
  notice.text("It's a Draw!")

$ ->
  _setupElements()
  _setupEvents()
