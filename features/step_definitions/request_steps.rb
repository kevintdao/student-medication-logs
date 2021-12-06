
Given /^I am on the create request page$/ do
  visit '/requests/new'
end

When /^I set time for "(.*?)"$/ do |time|
  page.find_by_id("time1", visible: false).set(time)
end

When /^I set start date to "(.*?)"$/ do |date|
  page.find_by_id("start_date", visible: false).set(date)
end

When /^I set end date to "(.*?)"$/ do |date|
  page.find_by_id("end_date", visible: false).set(date)
end

When /^I click Submit Request$/ do
  click_button('Submit Request')
end

Then /^I should be on "(.*?)" dashboard$/ do |user|
  case user
  when 'student'
    expect(page.current_path).to eq('/students')
  when 'parent'
    expect(page.current_path).to eq('/parents')
  when 'admin'
    expect(page.current_path).to eq('/admins')
  when 'nurse'
    expect(page.current_path).to eq('/nurses')
  end
end

Then /^I should not be on "(.*?)" dashboard$/ do |user|
  case user
  when 'student'
    expect(page.current_path).not_to eq('/students')
  when 'parent'
    expect(page.current_path).not_to eq('/parents')
  when 'admin'
    expect(page.current_path).not_to eq('/admins')
  when 'nurse'
    expect(page.current_path).not_to eq('/nurses')
  end
end

When /^I select "(.*?)" from "(.*?)" dropdown$/ do |value, field|
  if field == 'Your Student'
    select(value, from: 'student_id')
  end
end