Given /^I am on the nurse dashboard$/ do
  visit nurses_path
end

Then /^I should see the nurse dashboard$/ do
  expect(page.has_content?("Click the button below to see upcoming events.")).to be_truthy
end

When /^I click the link called "(.*?)"$/ do |link|
  click_link link
end

Then /^I should see a page with content "(.*?)"$/ do |content|
  expect(page.has_content?(content)).to be_truthy
end