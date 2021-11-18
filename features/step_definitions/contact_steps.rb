# Step definition for features involving contact us page --needs fixed

Given /^I am on the contact page$/ do
  visit 'home/contact'
end

When /^I click submit$/ do
  # fill_in field, with: value
  page.find("#submit").click
end

Then /^I should see the confirmation message$/ do
  page.should have_css('.alert-success', text: "Message successfully sent")
  #expect(home_send_contact_message_path).to receive(nil)
end

Then /^I should not see the confirmation message$/ do
  page.should_not have_css('.alert-success', text: "Message successfully sent")
end

When /^I enter (.*) for id name$/ do |value|
  fill_in "name", :with => value
end

When /^I enter (.*) for id email$/ do |value|
  fill_in "email", :with => value
end

When /^I enter (.*) for id subject$/ do |value|
  fill_in "subject", :with => value
end

When /^I enter (.*) for id message$/ do |value|
  fill_in "message", :with => value
end