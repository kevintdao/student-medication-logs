
Given /^I am logged in as an "(.*?)"$/ do |user_type|
  visit '/login'
  email = ''
  case user_type
  when 'admin'
    email = 'admin1@gmail.com'
  when 'nurse'
    email = 'nurse1@gmail.com'
  when 'parent'
    email = 'parent1a@gmail.com'
  when 'student'
    email = 'studenta@gmail.com'
  end
  find_field('loginEmail').set(email)
  find_field('loginPassword').set('123456')
  click_button('Login')
  @current_user = User.find_by_email(email)
end

Given /^I am on the edit users page$/ do
  id = @current_user.id.to_s
  visit "users/#{id}/edit"
end

Then /^I should see my "(.*?)" in the input box$/ do |field|
  case field
  when 'First Name'
    expect(find_field(field).value).to eq(@current_user.first_name)
  when 'Last Name'
    expect(find_field(field).value).to eq(@current_user.last_name)
  when 'Email Address'
    expect(find_field(field).value).to eq(@current_user.email)
  when 'Enable Email Notifications'
    @current_user.email_notification ? (expect(find_field(field).checked?).to eq(true)) : (expect(find_field(field).checked?).to eq(false))
  when 'Enable Text Notifications'
    @current_user.text_notification ? (expect(find_field(field).checked?).to eq(true)) : (expect(find_field(field).checked?).to eq(false))
  when 'Phone Number'
    expect(find_field(field).value).to eq(@current_user.phone)
  when 'District Name'
    expect(find_field(field).value).to eq(District.find(@current_user.district_id).district_name)
  when 'Address'
    expect(find_field(field).value).to eq(District.find(@current_user.district_id).address1)
  when 'City'
    expect(find_field(field).value).to eq(District.find(@current_user.district_id).city)
  when 'State'
    expect(find_field(field).value).to eq(District.find(@current_user.district_id).state)
  when 'Zip Code'
    expect(find_field(field).value).to eq(District.find(@current_user.district_id).zipcode)
  end
end

When /^I change my "(.*?)" to "(.*?)"$/ do |field, input|
  if field == 'Enable Email Notifications' || field == 'Enable Text Notifications'
    find_field(field).value == '1' ? uncheck(field) : check(field)
  elsif field == 'State'
    select(input, :from => field)
  else
    find_field(field).set(input)
  end
  click_button('Save Changes')
end

Then /^I should see "(.*?)" as my "(.*?)" on the page$/ do |value, field|
  unless (field == 'Enable Email Notifications' || field == 'Enable Text Notifications'|| field == 'Phone Number')
    expect(find_field(field).value).to eq(value)
  end
  if (field == 'Phone Number')
    expect(find_field(field).value).to eq("(" + value[0,3] + ") " + value[3,3] + "-" + value[6,4])
  end
  case field
  when 'First Name'
    expect(value).to eq(User.find(@current_user.id).first_name)
  when 'Last Name'
    expect(value).to eq(User.find(@current_user.id).last_name)
  when 'Email Address'
    expect(value).to eq(User.find(@current_user.id).email)
  when 'Enable Email Notifications'
    notif = User.find(@current_user.id).email_notification
    notif ? (expect(find_field(field).checked?).to eq(true)) : (expect(find_field(field).checked?).to eq(false))
  when 'Enable Text Notifications'
    notif = User.find(@current_user.id).text_notification
    notif ? (expect(find_field(field).checked?).to eq(true)) : (expect(find_field(field).checked?).to eq(false))
  when 'Phone Number'
    expect(value).to eq(User.find(@current_user.id).phone)
  when 'District Name'
    expect(value).to eq(District.find(@current_user.district_id).district_name)
  when 'Address'
    expect(value).to eq(District.find(@current_user.district_id).address1)
  when 'City'
    expect(value).to eq(District.find(@current_user.district_id).city)
  when 'State'
    expect(value).to eq(District.find(@current_user.district_id).state)
  when 'Zip Code'
    expect(value).to eq(District.find(@current_user.district_id).zipcode)
  end
end

Then /^I should not see a different "(.*?)"?/ do |field|
  case field
  when 'Phone Number'
    expect(find_field(field).value).to eq(@current_user.phone) # no change from original saved value
  end
end