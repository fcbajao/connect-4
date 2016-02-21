$ = require("jquery")
Game = require("game")
Player = require("player")

describe "game", ->
  game = null
  player1 = new Player("Irvine")
  player2 = new Player("Cloud")
  board = null

  beforeEach ->
    fixture.set("<div class='board'></div>", append = false)
    board = $(".board")
    game = new Game(player1, player2, board, {onTurnStart: $.noop, onVictory: $.noop})

  describe "constructor", ->
    it "sets the game's player1", ->
      expect(game.player1).toEqual(player1)

    it "sets the game's player2", ->
      expect(game.player2).toEqual(player2)

    it "sets grid with empty columns (x's contains empty y's)", ->
      for n in [0..6]
        expect(game.grid[n].length).toEqual(0)

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
    beforeEach ->
      spyOn(game, "getActivePlayer").and.returnValue(player2)
      spyOn(game, "placeChip")
      slot = game.board.find("[data-x='2']")[0]
      event = $.Event("click")
      event.target = slot
      game.board.trigger(event)

    it "calls #placeChip with the correct x and active player", ->
      expect(game.placeChip).toHaveBeenCalledWith(2, player2)

  describe "#placeChip", ->
    beforeEach ->
      spyOn(game, "determineTurnResult")

    describe "and the column is empty", ->
      beforeEach ->
        game.placeChip(0, player2)

      it "sets the player class on the bottom slot of the column", ->
        slot = game.board.find("[data-x='0'][data-y='0']")
        expect(slot.hasClass("player-2")).toBe(true)

      it "sets player on the grid", ->
        expect(game.grid[0][0]).toEqual(player2)

      it "calls #determineTurnResult with the latest x and y", ->
        expect(game.determineTurnResult).toHaveBeenCalledWith(0, 0)

    describe "and the column is not empty", ->
      beforeEach ->
        game.grid[2][0] = player2
        game.placeChip(2, player1)

      it "sets the player class on the next available slot on the column", ->
        slot = game.board.find("[data-x='2'][data-y='1']")
        expect(slot.hasClass("player-1")).toBe(true)

      it "sets player on the grid", ->
        expect(game.grid[2][1]).toEqual(player1)

      it "calls #determineTurnResult with the latest x and y", ->
        expect(game.determineTurnResult).toHaveBeenCalledWith(2, 1)

    describe "and the column is full", ->
      beforeEach ->
        game.grid[2][0] = player2
        game.grid[2][1] = player1
        game.grid[2][2] = player2
        game.grid[2][3] = player1
        game.grid[2][4] = player2
        game.grid[2][5] = player1
        game.placeChip(2, player1)

      it "does not set player on the grid", ->
        expect(game.grid[2][6]).toBeUndefined()

      it "does not call #determineTurnResult", ->
        expect(game.determineTurnResult).not.toHaveBeenCalled()

  describe "#determineTurnResult", ->
    describe "there's a winner", ->
      beforeEach ->
        spyOn(game, "onVictory")

      describe "diagonal backward '/' victory", ->
        beforeEach ->
          game.grid[0][1] = player1
          game.grid[1][2] = player1
          game.grid[2][3] = player1
          game.grid[3][4] = player1
          game.grid[4][5] = player1
          game.determineTurnResult(1, 2)

        it "calls #onVictory", ->
          expect(game.onVictory).toHaveBeenCalledWith(player1)

      describe "diagonal forward '\' victory", ->
        beforeEach ->
          game.grid[0][4] = player1
          game.grid[1][3] = player1
          game.grid[2][2] = player1
          game.grid[3][1] = player1
          game.grid[4][0] = player1
          game.determineTurnResult(2, 2)

        it "calls #onVictory", ->
          expect(game.onVictory).toHaveBeenCalledWith(player1)

      describe "horizontal victory", ->
        beforeEach ->
          game.grid[2][2] = player1
          game.grid[3][2] = player1
          game.grid[4][2] = player1
          game.grid[5][2] = player1
          game.grid[6][2] = player1
          game.determineTurnResult(4, 2)

        it "calls #onVictory", ->
          expect(game.onVictory).toHaveBeenCalledWith(player1)

      describe "vertical victory", ->
        beforeEach ->
          game.grid[0][5] = player1
          game.grid[0][4] = player1
          game.grid[0][3] = player1
          game.grid[0][2] = player1
          game.determineTurnResult(0, 5)

        it "calls #onVictory", ->
          expect(game.onVictory).toHaveBeenCalledWith(player1)

    describe "no winner yet", ->
      beforeEach ->
        spyOn(game, "onTurnStart")

      describe "broken diagonal backward '/'", ->
        beforeEach ->
          game.grid[0][1] = player1
          game.grid[1][2] = player1
          game.grid[2][3] = player2
          game.grid[3][4] = player1
          game.grid[4][5] = player1
          game.determineTurnResult(1, 2)

        it "calls #onTurnStart", ->
          expect(game.onTurnStart).toHaveBeenCalledWith(player2)

      describe "broken diagonal forward '\'", ->
        beforeEach ->
          game.grid[0][4] = player1
          game.grid[1][3] = player1
          game.grid[2][2] = player2
          game.grid[3][1] = player1
          game.grid[4][0] = player1
          game.determineTurnResult(4, 0)

        it "calls #onVictory", ->
          expect(game.onTurnStart).toHaveBeenCalledWith(player2)

      describe "broken horizontal", ->
        beforeEach ->
          game.grid[2][2] = player1
          game.grid[3][2] = player1
          game.grid[4][2] = player2
          game.grid[5][2] = player1
          game.grid[6][2] = player1
          game.determineTurnResult(2, 2)

        it "calls #onVictory", ->
          expect(game.onTurnStart).toHaveBeenCalledWith(player2)

      describe "broken vertical", ->
        beforeEach ->
          game.grid[0][5] = player1
          game.grid[0][4] = player2
          game.grid[0][3] = player1
          game.grid[0][2] = player1
          game.determineTurnResult(0, 5)

        it "calls #onVictory", ->
          expect(game.onTurnStart).toHaveBeenCalledWith(player2)

  describe "#onTurnStart", ->
    beforeEach ->
      spyOn(game.options, "onTurnStart")
      game.onTurnStart(player2)

    it "sets active player", ->
      expect(game.getActivePlayer()).toEqual(player2)

    it "calls the onTurnStart callback", ->
      expect(game.options.onTurnStart).toHaveBeenCalledWith(player2)

  describe "#onVictory", ->
    beforeEach ->
      spyOn(game.options, "onVictory")
      game.onVictory(player2)

    it "sets victor", ->
      expect(game.victor).toEqual(player2)

    it "calls the onVictory callback", ->
      expect(game.options.onVictory).toHaveBeenCalledWith(player2)
