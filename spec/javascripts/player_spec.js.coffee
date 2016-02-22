Player = require("player")

describe "Player", ->
  describe "constructor", ->
    player = null

    beforeEach ->
      player = new Player("Patrick")

    it "sets the player's name", ->
      expect(player.name).toEqual("Patrick")

    it "sets the bot to false by default", ->
      expect(player.bot).toBe(false)
