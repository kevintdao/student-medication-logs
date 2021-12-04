# Step definition for features involving inventory controller and views


When /^I visit the inventory page$/ do
  visit inventories_path
end

When /^I enter "(.*?)" into the text box with ID "(.*?)"$/ do |value, id|
  fill_in id, :with => value
end