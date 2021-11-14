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

Then /^The database should contain a school district with the name "(.*?)" and an admin with the email "(.*?)"$/ do |district_name, email|
  dis = District.where(:district_name => district_name)
  expect(dis).to be_truthy
  user = User.where(:email => email)
  expect(user).to be_truthy

end
