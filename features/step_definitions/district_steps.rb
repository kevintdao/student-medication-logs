# Completed step definitions for basic features:

Given /^I am on the District Registration page$/ do
  visit 'users/register'
end

When /^I enter "(.*?)" as "(.*?)"$/ do |value, field|
  # fill_in field, with: value
  find_field(field).set(value)
end

When /^I click Register District$/ do 
  %(I press "submit")
end

Then /^The database should contain a school district with the name "(.*?)" and an admin with the name "(.*?)"$/ do |district_name, user_name|
  dis = District.find_by(:district_name, district_name)
  expect(dis).to be_truthy
  first_name = user_name.split(' ').first
  last_name = user_name.split(' ').second
  user = User.find_by(:first_name, first_name)
  expect(user).to be_truthy
  expect(user.last_name).to eq(last_name)

end
