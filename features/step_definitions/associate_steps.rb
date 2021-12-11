When /^I enter "(.*)" into "(.*)" fields$/ do |name, field|
  name_split = name.split
  fill_in("#{field}_first", with: name_split[0])
  fill_in("#{field}_last", with: name_split[1])
end

Given(/^I am on the nurse associate page$/) do
  visit nurses_associate_page_path
end

Given(/^I am on the admin associate page$/) do
  visit admins_associate_page_path
end

When /^I select "(.*)" in "(.*)" menu$/ do |name, menu|
  role_id = User.where(first_name: name.split(' ')[0], last_name: name.split(' ')[1])[0].role
  select(role_id, :from => menu)
end