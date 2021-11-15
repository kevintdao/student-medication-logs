# Step definitions for features involving the medications page --needs fixed

Given /^I am on the medication page$/ do
  visit medications_path
end

Then /^I should see all medications$/ do
  page.all('table#dtBasicExample tr').count.should == 10
end

Then /^I should see medications with (.*?)$/ do |search_term|
  page.has_content?(search_term) and not page.has_content("8-MOP")
end

When /^I enter (.*?) in the search box$/ do |search_term|
  page.find("#form1").set(search_term)
end

When /^I click search$/ do
  page.find("submit").click
end