
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

Given /^"(.*?)" is a child of "(.*?)"$/ do |child, parent|
  the_child = User.where(first_name: child.split.first, last_name: child.split.last).first
  the_child = Student.find(the_child.role_id)
  the_parent = User.where(first_name: parent.split.first, last_name: parent.split.last).first
  the_parent = Parent.find(the_parent.role_id)
  expect(the_child).not_to be_nil
  expect(the_parent).not_to be_nil
  expect(the_parent.students.find { |s| s == the_child }).not_to be_nil
  expect(the_child.parents.find { |p| p == the_parent }).not_to be_nil
end

Given /^A request by "(.*?)" has been made$/ do |student|
  the_student = User.where(first_name: student.split.first, last_name: student.split.last).first
  expect(Request.all.find { |r| r.student_id == the_student.id }).not_to be_nil
end

When /^I click the View Requests for Approval button$/ do
  find(:id, 'view-requests').click
end

Then /^I should be on the requests page$/ do
  expect(page.current_path).to eq('/requests')
end

Then /^I should see the request for "(.*?)" to take "(.*?)" with "(.*?)" daily doses$/ do |student, medication, doses|
  matches = 0
  page.all('tr').each do |tr|
    row = tr.text
    if row.include?(student) && row.include?(doses) && row.include?(medication) then matches += 1 end
  end
  expect(matches).to be > 0
end

When /^I click Approve Request for "(.*?)" with "(.*?)" daily doses$/ do |student, doses|
  std_user = User.where(first_name: student.split.first, last_name: student.split.last).first
  request = Request.where(student_id: std_user.id, daily_doses: doses).first
  find(:id, 'approve-btn-' + request.id.to_s).click
end

Then /^The request for "(.*?)" with "(.*?)" daily doses should be "(.*?)" approved and "(.*?)" approved$/ do |student, doses, user1, user2|
  std_user = User.where(first_name: student.split.first, last_name: student.split.last).first
  request = Request.where(student_id: std_user.id, daily_doses: doses).first
  case user1 + ' ' + user2
  when 'parent nurse'
    expect(request.parent_approved).to be_truthy
    expect(request.nurse_approved).to be_truthy
  when 'parent not nurse'
    expect(request.parent_approved).to be_truthy
    expect(request.nurse_approved).to be_falsey
  when 'nurse parent'
    expect(request.parent_approved).to be_truthy
    expect(request.nurse_approved).to be_truthy
  when 'nurse not parent'
    expect(request.parent_approved).to be_falsey
    expect(request.nurse_approved).to be_truthy
  end
end