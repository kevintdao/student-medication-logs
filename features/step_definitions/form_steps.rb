# Step definition for features involving form controller and views

When /^I visit the forms page$/ do
  visit forms_path
end

When /^I visit the parent forms page$/ do
  visit forms_parent_view_path
end

When /^I visit the new form page$/ do
  visit forms_new_path
end