Feature: Multiplayer Game
  In order to enjoy the game with friends
  As a user
  I should be able to play with another human player

  Background:
    When I visit the home page
    And I enter "Erick" as the first player
    And I enter "Mags" as the second player
    And I click on the button to start a new game
    Then I should see the game begin

  @javascript
  Scenario: Win by connecting 4 vertically
    When player 1 drops a chip on column 1
    And player 2 drops a chip on column 2
    And player 1 drops a chip on column 1
    And player 2 drops a chip on column 2
    And player 1 drops a chip on column 1
    And player 2 drops a chip on column 2
    And player 1 drops a chip on column 1
    Then I should see "Erick Wins!"

  @javascript
  Scenario: Draw
    When player 1 drops a chip on column 1
    And player 2 drops a chip on column 1
    And player 1 drops a chip on column 1
    And player 2 drops a chip on column 1
    And player 1 drops a chip on column 1
    And player 2 drops a chip on column 1
    And player 1 drops a chip on column 2
    And player 2 drops a chip on column 2
    And player 1 drops a chip on column 2
    And player 2 drops a chip on column 2
    And player 1 drops a chip on column 2
    And player 2 drops a chip on column 2
    And player 1 drops a chip on column 7
    And player 2 drops a chip on column 3
    And player 1 drops a chip on column 3
    And player 2 drops a chip on column 3
    And player 1 drops a chip on column 3
    And player 2 drops a chip on column 3
    And player 1 drops a chip on column 3
    And player 2 drops a chip on column 4
    And player 1 drops a chip on column 4
    And player 2 drops a chip on column 4
    And player 1 drops a chip on column 4
    And player 2 drops a chip on column 4
    And player 1 drops a chip on column 4
    And player 2 drops a chip on column 7
    And player 1 drops a chip on column 5
    And player 2 drops a chip on column 5
    And player 1 drops a chip on column 5
    And player 2 drops a chip on column 5
    And player 1 drops a chip on column 5
    And player 2 drops a chip on column 5
    And player 1 drops a chip on column 6
    And player 2 drops a chip on column 6
    And player 1 drops a chip on column 6
    And player 2 drops a chip on column 6
    And player 1 drops a chip on column 6
    And player 2 drops a chip on column 6
    And player 1 drops a chip on column 7
    And player 2 drops a chip on column 7
    And player 1 drops a chip on column 7
    And player 2 drops a chip on column 7
    Then I should see "It's a Draw!"
