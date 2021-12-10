When /^I enter "(.*)" into "(.*)" fields$/ do |name, field|
  name_split = name.split
  fill_in("#{field}_first", with: name_split[0])
  fill_in("#{field}_last", with: name_split[1])
end

Given /^"(.*)" and "(.*)" are already associated $/ do |name1, name2|
  parent_id = User.where(first_name: name2.split(' ')[0], last_name: name2.split(' ')[1])[0].role_id
  student_id = User.where(first_name: name1.split(' ')[0], last_name: name1.split(' ')[1])[0].role_id
  select(student_id, 'student')
  select(parent_id, 'parent')
  
  click_button('Submit')
end

Given(/^I am on the associate page$/) do
  visit nurses_associate_page_path
end

When /^I select "(.*)" in "(.*)" menu$/ do |name, menu|
  role_id = User.where(first_name: name.split(' ')[0], last_name: name.split(' ')[1])[0].role_id
  select(role_id, menu)
end