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

    player1 = form.find("#first_player_name").val()
    player2 = form.find("#second_player_name").val()

    if player1 isnt "" and player2 isnt ""
      player1 = new Player(player1)
      player2 = new Player(player2)
      game.destroy() if game?
      game = new Game(player1, player2, board, onTurnStart: _onTurnStart, onVictory: _onVictory)
    else
      alert("You must enter names for both players.")

_onTurnStart = (player) ->
  notice.text("It's #{player.name}'s turn.")

_onVictory = (player) ->
  notice.text("#{player.name} Wins!")

$ ->
  _setupElements()
  _setupEvents()
