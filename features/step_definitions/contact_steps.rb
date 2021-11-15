# Step definition for features involving contact us page --needs fixed

Given /^I am on the contact page$/ do
  visit 'home/contact'
end

When /^I click submit"$/ do
  # fill_in field, with: value
  page.find("#submit").click
end

Then /^I should see the confirmation message$/ do
  expect(flash[:notice]).to match(/Message successfully sent/)
end

Then /^I should not see the confirmation message$/ do
  not page.has_content?("Message successfully sent")
end