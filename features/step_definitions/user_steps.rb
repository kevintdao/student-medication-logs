Given /^I am on the Users page$/ do
  visit users_path
end

Given /^I am on the login page$/ do
  visit login_path
end

Given /^I am logged in as an admin$/ do
  visit login_path
  fill_in('loginEmail', with: 'admin1@gmail.com')
  fill_in('loginPassword', with: '123456')
  click_button('Login')
end

Given /^I am logged in as a nurse$/ do
  visit login_path
  fill_in('loginEmail', with: 'nurse1@gmail.com')
  fill_in('loginPassword', with: '123456')
  click_button('Login')
end

When /^I search by "(.*)" for the term "(.*)"$/ do |type, term|
  select(type, from: 'search_type')
  fill_in('search_term', with: term)
  click_button('Search')
end

Then /^I should see user with the name of "(.*)"$/ do |name|
  expect(page).to have_xpath("//td[text()='#{name}']")
end

Then /^I should not see user with the name of "(.*)"$/ do |name|
  expect(page).not_to have_xpath("//td[text()='#{name}']")
end

Given /^I am on the nurse dashboard$/ do
  visit nurses_path
end

Then /^I should see the nurse dashboard$/ do
  expect(page.has_content?("Click the button below to see upcoming events.")).to be_truthy
end

Given /^I am on the parent dashboard$/ do
  visit parents_path
end

Then /^I should see the parent dashboard$/ do
  expect(page.has_content?("Click the button below to see upcoming events.")).to be_truthy
end

Given /^I am on the student dashboard$/ do
  visit students_path
end

Then /^I should see the student dashboard$/ do
  expect(page.has_content?("Click the button below to see upcoming events.")).to be_truthy
end

When /^I click the link called "(.*?)"$/ do |link|
  click_link link
end

Then /^I should see a page with content "(.*?)"$/ do |content|
  expect(page.has_content?(content)).to be_truthy
end

When /^I click "([^"]*)"$/ do |arg1|
  click_on arg1
end

Then /^I should see the "([^"]*)" page$/ do |arg1|
  expect(page).to have_content(arg1)
end

When /^I login with email = "([^"]*)", password = "([^"]*)"$/ do |email, password|
  fill_in('loginEmail', with: email)
  fill_in('loginPassword', with: password)
  click_button('Login')
end

Then /^I should see "([^"]*)" notice$/ do |arg1|
  expect(page).to have_content(arg1)
end

Then /^I should see "([^"]*)" button$/ do |arg1|
  expect(page).to have_content(arg1)
end

Then /^I should not see "([^"]*)" button$/ do |arg1|
  expect(page).not_to have_content(arg1)
end