
Given /^I am on the create users page$/ do
  visit 'users/new'
end

When /^I click Invite User$/ do
  click_button('Invite User')
end

When /^(?:I|they) click Set Password$/ do
  click_button('Set Password')
end

When /^(?:I|they) select "(.*?)" from "(.*?)"$/ do |value, field|
  select(value, :from => field)
end

Then /^The database should contain a user with the email "(.*?)"$/ do |email|
  user = User.where(:email => email)
  expect(user.length).not_to eq(0)
end

Then /^(?:I|they) should see "(.*?)"$/ do |text|
  expect(page.has_content?(text)).to be_truthy
end