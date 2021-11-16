# Completed step definitions for basic features:

Given /^I am on the District Registration page$/ do
  visit 'users/register'
end

When /^I enter "(.*?)" as "(.*?)"$/ do |value, field|
  # fill_in field, with: value
  find_field(field).set(value)
end

When /^I click Register District$/ do
  click_button('Register District')
end

Then /^The database should contain a school district with the name "(.*?)" and an admin with the email "(.*?)"$/ do |district_name, email|
  dis = District.where(:district_name => district_name)
  expect(dis.length).not_to eq(0)
  user = User.where(:email => email)
  expect(user.length).not_to eq(0)
end

Then /^I should be on the login page$/ do
  expect(page.current_path).to eq('/users/login')
end

Then /^I should not be on the login page$/ do
  expect(page.current_path).not_to eq('/users/login')
end