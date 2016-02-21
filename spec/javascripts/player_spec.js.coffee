Player = require("player")

describe "player", ->
  describe "constructor", ->
    player = null

    beforeEach ->
      player = new Player("Patrick")

    it "sets the player's name", ->
      expect(player.name).toEqual("Patrick")
