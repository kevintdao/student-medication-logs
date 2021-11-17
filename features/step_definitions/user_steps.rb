Given /the following users have been added to SML:/ do |users_table|
  users_table.hashes.each do |user|
    User.create!(user)
  end
end

Given /^I am on the Users page$/ do
  visit 'users'
end

When /^I search by (.*) for the term (.*)$/ do |type, term|
  select(type, from: 'search_type')
  fill_in('search_term', with: 'term')
  click_button('Search')
end

Then /^I should see user with the name of (.*)$/ do |name|
  expect(page).to have_content(name)
end

Then /^I should not see user with the name of (.*)$/ do |name|
  expect(page).not_to have_content(name)
end
