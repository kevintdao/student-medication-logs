# Step definition for features involving homepage

Given /^I am on the homepage$/ do
  visit 'home/index'
end

When /^I click the SML logo$/ do
  page.find("#main-logo").click
end

Then /^I should see the landing page$/ do
  expect(page.has_content?("Welcome to Student Medication Log")).to be_truthy
end

When /^I click the (.*?) link$/ do |link|
  page.find("#%s" % link).click
end

Then /^I should see the About page$/ do
  expect(page.has_content?("Get texts when it's time for a medication")).to be_truthy
end

Then /^I should see the Medications page$/ do
  expect(page.has_content?("Medications")).to be_truthy
end

Then /^I should see the Contact Us page$/ do
  expect(page.has_content?("Further questions about SML?")).to be_truthy
end


