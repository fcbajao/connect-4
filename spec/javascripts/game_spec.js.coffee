$ = require("jquery")
Game = require("game")
Player = require("player")

describe "Game", ->
  game = null
  player1 = null
  player2 = null
  board = null

  beforeEach ->
    player1 = new Player("Irvine")
    player2 = new Player("Cloud")
    spyOn(Game.prototype, "onTurnStart").and.callThrough()

    fixture.set("<div class='board'></div>", append = false)
    board = $(".board")

    game = new Game(player1, player2, board, {onTurnStart: $.noop, onVictory: $.noop, onDraw: $.noop})
    expect(Game.prototype.onTurnStart).toHaveBeenCalledWith(player1)

  describe "constructor", ->
    it "sets the game's player1", ->
      expect(game.player1).toEqual(player1)

    it "sets the game's player2", ->
      expect(game.player2).toEqual(player2)

    it "sets initial game state", ->
      expect(game.currentState).toBeDefined()

    it "sets the enabled class on the board", ->
      expect(game.board.hasClass("enabled")).toBe(true)

    it "renders the empty slots on the board", ->
      slots = game.board.find(".slot")
      x = 0
      y = 5

      for n in [0..41]
        slot = $(slots[n])
        expect(slot.data("x")).toEqual(x)
        expect(slot.data("y")).toEqual(y)
        if x is 6
          x = 0
          y -= 1
        else
          x += 1

  describe "when a slot is clicked", ->
    event = null

    beforeEach ->
      spyOn(game, "getCurrentTurn").and.returnValue(player2)
      spyOn(game, "makeMove")
      slot = game.board.find("[data-x='2']")[0]
      event = $.Event("click")
      event.target = slot

    describe "and active player is not a bot", ->
      beforeEach ->
        spyOn(game.currentState, "getAvailableMoves").and.returnValue([2])
        spyOn(game.currentState, "isOver").and.returnValue(false)
        game.board.trigger(event)

      it "calls #makeMove with the correct x and active player", ->
        expect(game.makeMove).toHaveBeenCalledWith(2, player2)

    describe "and active player is a bot", ->
      beforeEach ->
        spyOn(game.currentState, "getAvailableMoves").and.returnValue([2])
        spyOn(game.currentState, "isOver").and.returnValue(false)
        player2.bot = true
        game.board.trigger(event)

      it "does not call #makeMove", ->
        expect(game.makeMove).not.toHaveBeenCalled()

    describe "and game is over", ->
      beforeEach ->
        spyOn(game.currentState, "getAvailableMoves").and.returnValue([2])
        spyOn(game.currentState, "isOver").and.returnValue(true)
        game.board.trigger(event)

      it "does not call #makeMove", ->
        expect(game.makeMove).not.toHaveBeenCalled()

    describe "and column is full", ->
      beforeEach ->
        spyOn(game.currentState, "isOver").and.returnValue(false)
        spyOn(game.currentState, "getAvailableMoves").and.returnValue([0, 1, 3, 4, 5, 6])
        game.board.trigger(event)

      it "does not call #makeMove", ->
        expect(game.makeMove).not.toHaveBeenCalled()

  describe "#makeMove", ->
    beforeEach ->
      spyOn(game.currentState, "makeMove")
      spyOn(game.currentState, "getLastMove").and.returnValue({x: 0, y: 0, player: player2})

    describe "in general", ->
      beforeEach ->
        spyOn(game.currentState, "getAvailableMoves").and.returnValue([0, 1, 2])
        game.makeMove(0, player2)

      it "sets the player class on the slot", ->
        slot = game.board.find("[data-x='0'][data-y='0']")
        expect(slot.hasClass("player-2")).toBe(true)

    describe "there's a winner", ->
      beforeEach ->
        spyOn(game.currentState, "getAvailableMoves").and.returnValue([0, 1, 2])
        spyOn(game.currentState, "getWinner").and.returnValue(player2)
        spyOn(game, "onVictory")
        game.makeMove(0, player2)

      it "calls #onVictory", ->
        expect(game.onVictory).toHaveBeenCalledWith(player2)

    describe "there's a draw", ->
      beforeEach ->
        spyOn(game.currentState, "getAvailableMoves").and.returnValue([])
        spyOn(game.currentState, "getWinner").and.returnValue(null)
        spyOn(game, "onDraw")
        game.makeMove(0, player2)

      it "calls #onDraw", ->
        expect(game.onDraw).toHaveBeenCalled()

    describe "no winner yet", ->
      beforeEach ->
        spyOn(game.currentState, "getAvailableMoves").and.returnValue([0, 1, 2])
        spyOn(game.currentState, "getWinner").and.returnValue(null)
        game.makeMove(0, player2)

      it "calls #onTurnStart for the next player", ->
        expect(game.onTurnStart).toHaveBeenCalledWith(player1)

  describe "#onTurnStart", ->
    describe "in general", ->
      beforeEach ->
        spyOn(game.options, "onTurnStart")
        game.onTurnStart(player2)

      it "sets active player", ->
        expect(game.getCurrentTurn()).toEqual(player2)

      it "calls the onTurnStart callback", ->
        expect(game.options.onTurnStart).toHaveBeenCalledWith(player2)

    describe "when player is a bot", ->
      beforeEach ->
        player1.bot = true
        spyOn(player1, "requestMove").and.returnValue(2)
        spyOn(game, "makeMove")
        game.onTurnStart(player1)

      it "calls #requestMove on the bot", ->
        expect(player1.requestMove).toHaveBeenCalledWith(game)
        expect(game.makeMove).toHaveBeenCalledWith(2, player1)

  describe "#onVictory", ->
    beforeEach ->
      spyOn(game.options, "onVictory")
      game.onVictory(player2)

    it "calls the onVictory callback", ->
      expect(game.options.onVictory).toHaveBeenCalledWith(player2)

  describe "#onDraw", ->
    beforeEach ->
      spyOn(game.options, "onDraw")
      game.onDraw()

    it "calls the onDraw callback", ->
      expect(game.options.onDraw).toHaveBeenCalled()
