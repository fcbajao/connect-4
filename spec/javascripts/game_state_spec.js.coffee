$ = require("jquery")
GameState = require("game_state")
Player = require("player")

describe "GameState", ->
  state = null

  describe "constructor", ->
    describe "previous state was not given", ->
      beforeEach ->
        state = new GameState

      it "sets grid with empty columns (x's contains empty y's)", ->
        for n in [0..6]
          expect(state.grid[n].length).toEqual(0)

    describe "previous state was given", ->
      player = null
      oldState = null

      beforeEach ->
        player = new Player("Jin")
        oldState = new GameState
        oldState.grid[0][0] = player
        oldState.grid[0][1] = player
        oldState.grid[0][2] = player
        oldState.lastMove = {x: 0, player: player}
        state = new GameState(oldState)

      it "copies the grid from the previous state", ->
        expect(state.grid[0][0]).toEqual(oldState.grid[0][0])
        expect(state.grid[0][1]).toEqual(oldState.grid[0][1])
        expect(state.grid[0][2]).toEqual(oldState.grid[0][2])

      it "copies the lastMove from the previous state", ->
        expect(state.lastMove.x).toEqual(oldState.lastMove.x)
        expect(state.lastMove.player).toEqual(oldState.lastMove.player)

  describe "#isOver", ->
    player = null

    beforeEach ->
      player = new Player("Zell")
      state = new GameState

    describe "when there's a winner",  ->
      beforeEach ->
        spyOn(state, "getAvailableMoves").and.returnValue([0])
        spyOn(state, "getWinner").and.returnValue(player)

      it "returns true", ->
        expect(state.isOver()).toBe(true)

    describe "when there are no more moves left",  ->
      beforeEach ->
        spyOn(state, "getAvailableMoves").and.returnValue([])
        spyOn(state, "getWinner").and.returnValue(null)

      it "returns true", ->
        expect(state.isOver()).toBe(true)

  describe "#getAvailableMoves", ->
    beforeEach ->
      state = new GameState

      state.grid[0][0] = true
      state.grid[0][1] = true
      state.grid[0][2] = true
      state.grid[0][3] = true
      state.grid[0][4] = true

      state.grid[2][0] = true
      state.grid[2][1] = true
      state.grid[2][2] = true
      state.grid[2][3] = true
      state.grid[2][4] = true
      state.grid[2][5] = true

      state.grid[3][0] = true
      state.grid[3][1] = true
      state.grid[3][2] = true
      state.grid[3][3] = true

    it "returns an array of available columns to make a move on", ->
      cols = state.getAvailableMoves()
      expect(cols).toEqual([0, 1, 3, 4, 5, 6])

  describe "#makeMove", ->
    player = null

    beforeEach ->
      player = new Player("Squall")
      state = new GameState
      spyOn(state, "checkWinner")

    describe "and the column is empty", ->
      beforeEach ->
        state.makeMove(0, player)

      it "sets player on the slot", ->
        expect(state.grid[0][0]).toEqual(player)

      it "calls #checkWinner with the latest x and y", ->
        expect(state.checkWinner).toHaveBeenCalledWith(0, 0)

      it "sets lastMove", ->
        expect(state.getLastMove()).toEqual({x: 0, y: 0, player: player})

    describe "and the column is not empty", ->
      beforeEach ->
        state.grid[2][0] = player
        state.makeMove(2, player)

      it "sets player on the top available slot of the column", ->
        expect(state.grid[2][1]).toEqual(player)

      it "calls #checkWinner with the latest x and y", ->
        expect(state.checkWinner).toHaveBeenCalledWith(2, 1)

      it "sets lastMove", ->
        expect(state.getLastMove()).toEqual({x: 2, y: 1, player: player})

  describe "#checkWinner", ->
    player1 = null
    player2 = null

    beforeEach ->
      player1 = new Player("Squall")
      player2 = new Player("Winter")
      state = new GameState

    describe "there's a winner", ->
      describe "diagonal backward '/' victory", ->
        beforeEach ->
          state.grid[0][1] = player1
          state.grid[1][2] = player1
          state.grid[2][3] = player1
          state.grid[3][4] = player1
          state.grid[4][5] = player1
          state.checkWinner(1, 2)

        it "sets winner", ->
          expect(state.getWinner()).toEqual(player1)

      describe "diagonal forward '\' victory", ->
        beforeEach ->
          state.grid[0][4] = player1
          state.grid[1][3] = player1
          state.grid[2][2] = player1
          state.grid[3][1] = player1
          state.grid[4][0] = player1
          state.checkWinner(2, 2)

        it "sets winner", ->
          expect(state.getWinner()).toEqual(player1)

      describe "horizontal victory", ->
        beforeEach ->
          state.grid[2][2] = player1
          state.grid[3][2] = player1
          state.grid[4][2] = player1
          state.grid[5][2] = player1
          state.grid[6][2] = player1
          state.checkWinner(4, 2)

        it "sets winner", ->
          expect(state.getWinner()).toEqual(player1)

      describe "vertical victory", ->
        beforeEach ->
          state.grid[0][5] = player1
          state.grid[0][4] = player1
          state.grid[0][3] = player1
          state.grid[0][2] = player1
          state.checkWinner(0, 5)

        it "sets winner", ->
          expect(state.getWinner()).toEqual(player1)

    describe "no winner yet", ->
      describe "broken diagonal backward '/'", ->
        beforeEach ->
          state.grid[0][1] = player1
          state.grid[1][2] = player1
          state.grid[2][3] = player2
          state.grid[3][4] = player1
          state.grid[4][5] = player1
          state.checkWinner(1, 2)

        it "sets no winner", ->
          expect(state.getWinner()).toBeUndefined()

      describe "broken diagonal forward '\'", ->
        beforeEach ->
          state.grid[0][4] = player1
          state.grid[1][3] = player1
          state.grid[2][2] = player2
          state.grid[3][1] = player1
          state.grid[4][0] = player1
          state.checkWinner(4, 0)

        it "sets no winner", ->
          expect(state.getWinner()).toBeUndefined()

      describe "broken horizontal", ->
        beforeEach ->
          state.grid[2][2] = player1
          state.grid[3][2] = player1
          state.grid[4][2] = player2
          state.grid[5][2] = player1
          state.grid[6][2] = player1
          state.checkWinner(2, 2)

        it "sets no winner", ->
          expect(state.getWinner()).toBeUndefined()

      describe "broken vertical", ->
        beforeEach ->
          state.grid[0][5] = player1
          state.grid[0][4] = player2
          state.grid[0][3] = player1
          state.grid[0][2] = player1
          state.checkWinner(0 ,5)

        it "sets no winner", ->
          expect(state.getWinner()).toBeUndefined()
