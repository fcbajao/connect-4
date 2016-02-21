When(/^I visit the home page$/) do
  visit "/"
end

When(/^I enter "([^"]*)" as the (first|second) player$/) do |name, player_number|
  fill_in "#{player_number}_player_name", with: name
end

When(/^I click on the button to start a new game$/) do
  page.find(".new-game-button").click
end

Then(/^I should see the game begin$/) do
  expect(page).to have_selector(".board .slot", count: 42)
end

When(/^player (?:1|2) drops a chip on column (\d+)$/) do |col_num|
  page.first("[data-x='#{col_num.to_i - 1}']").click
end

Then(/^I should see "([^"]*)"$/) do |text|
  expect(page).to have_content(text)
end
