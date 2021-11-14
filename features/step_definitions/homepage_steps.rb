# Step definition for features involving homepage

Given /^I am on the homepage$/ do
  visit 'home/index'
end

When /^I click the SML logo$/ do
  page.find("#main-logo").click
end

Then /^I should see the landing page$/ do
  page.has_content?("Welcome to Student Medication Log")
end

When /^I click the (.*?) link$/ do |link|
  page.find("#%s" % link).click
end

Then /^I should see the About page$/ do
  page.has_content?("Get texts when it's time for a medication")
end

Then /^I should see the Medications page$/ do
  page.has_content?("Medications")
end

Then /^I should see the Contact Us page$/ do
  page.has_content?("Further questions about SML?")
end


