# Step definitions for features involving the medications page --needs fixed

Given /^I am on the medication page$/ do
  visit medications_path
end

Then /^I should be on the medications page$/ do
  expect(page.has_content?("Medication")).to be_truthy
end

Then /^I should see medications with (.*?)$/ do |search_term|
  page.has_content?(search_term) and not page.has_content("8-MOP")
end

When /^I enter (.*) in the search box$/ do |search_term|
  fill_in "form1", :with => search_term
end

When /^I click search$/ do
  page.find("#submit").click
end