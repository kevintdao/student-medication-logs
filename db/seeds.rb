# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'

# csv_text = File.read(Rails.root.join('lib', 'seeds', 'drugs.csv'))
# csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
#
# csv.each do |row|
#   m = Medication.new
#   m.brand_name = row['DrugName']
#   m.active_ing = row['ActiveIngredient']
#   m.method = row['Form']
#   m.strength = row['Strength']
#   m.save
# end
#
# puts "There are now #{Medication.count} rows in the medications table"

events = [
  {time: DateTime.new(2021, 12, 15, 15, 0, 0), student_id: 5, med_id: 35, complete: false, notes: "This is a notes field for this event.", district: 1, amount: 1},
  {time: DateTime.new(2021, 12, 14, 12, 0, 0), student_id: 6, med_id: 32, complete: false, district: 1, amount: 2},
  {time: DateTime.new(2021, 12, 1, 9, 45, 0), student_id: 11, med_id: 400, complete: false, notes: "Here is a note for this event", district: 2, amount: 1},
  {time: DateTime.new(2021, 12, 5, 14, 30, 0), student_id: 5, med_id: 345, complete: false, notes: "Notes go into this field", district: 1, amount: 1},
  {time: DateTime.new(2021, 12, 10, 8, 0, 0), student_id: 7, med_id: 554, complete: true, notes: "This is an example of a completed event", district: 1, amount: 1}
]

events.each do |user|
  Event.create!(user)
end

puts "There are now #{Event.count} rows in the events table"

districts = [
  {district_name: 'Iowa City Community Schools', address1: '1234 1st Avenue', city: 'Iowa City', state: 'IA', zipcode: '52246'},
  {district_name: 'Coralville Community Schools', address1: '1234 1st Avenue', city: 'Coralville', state: 'IA', zipcode: '52240'}
]

districts.each do |district|
  District.create!(district)
end

inventory = [{med_id: 34, amount: 50, studentID: 6, districtID: 1, notes: "These are notes for this medication", medName: Medication.where(id: 34).first.brand_name},
             {med_id: 415, amount: 10, studentID: 5, districtID: 1, notes: nil, medName: Medication.where(id: 415).first.brand_name},
             {med_id: 1064, amount: 1, studentID: 5, districtID: 1, notes: "Some more notes can go here", medName: Medication.where(id: 1064).first.brand_name},
             {med_id: 6087, amount: 100, studentID: 7, districtID: 2, notes: "This is a medication for district 2", medName: Medication.where(id: 6087).first.brand_name}]

inventory.each do |item|
  Inventory.create!(item)
end

puts "There are now #{Inventory.count} rows in the inventories table"

users = [
  { email: 'admin1@gmail.com', first_name: 'Admin', last_name: '1', password: '123456', password_confirmation: '123456', role: 'Admin', district_id: 1, text_notification: false, email_notification: false },
  { email: 'nurse1@gmail.com', first_name: 'Nurse', last_name: '1', password: '123456', password_confirmation: '123456', role: 'Nurse', district_id: 1, text_notification: false, email_notification: false },
  { email: 'parent1a@gmail.com', first_name: 'Parent', last_name: '1A', password: '123456', password_confirmation: '123456', role: 'Parent', district_id: 1, text_notification: false, email_notification: false },
  { email: 'parent1b@gmail.com', first_name: 'Parent', last_name: '1B', password: '123456', password_confirmation: '123456', role: 'Parent', district_id: 1, text_notification: false, email_notification: false },
  { email: 'studenta@gmail.com', first_name: 'Student', last_name: 'A', password: '123456', password_confirmation: '123456', role: 'Student', district_id: 1, text_notification: false, email_notification: false },
  { email: 'studentb@gmail.com', first_name: 'Student', last_name: 'B', password: '123456', password_confirmation: '123456', role: 'Student', district_id: 1, text_notification: false, email_notification: false },
  { email: 'studentc@gmail.com', first_name: 'Student', last_name: 'C', password: '123456', password_confirmation: '123456', role: 'Student', district_id: 1, text_notification: false, email_notification: false },
  { email: 'admin2@gmail.com', first_name: 'Admin', last_name: '2', password: '123456', password_confirmation: '123456', role: 'Admin', district_id: 2, text_notification: false, email_notification: false },
  { email: 'nurse2@gmail.com', first_name: 'Nurse', last_name: '2', password: '123456', password_confirmation: '123456', role: 'Nurse', district_id: 2, text_notification: false, email_notification: false },
  { email: 'parent2@gmail.com', first_name: 'Parent', last_name: '2', password: '123456', password_confirmation: '123456', role: 'Parent', district_id: 2, text_notification: false, email_notification: false },
  { email: 'student2@gmail.com', first_name: 'Student', last_name: '2', password: '123456', password_confirmation: '123456', role: 'Student', district_id: 2, text_notification: false, email_notification: false }
]

users.each do |user|
  case user[:role]
  when 'Admin'
    user[:role_id] = Admin.create!.id
  when 'Nurse'
    user[:role_id] = Nurse.create!.id
  when 'Parent'
    user[:role_id] = Parent.create!.id
  when 'Student'
    user[:role_id] = Student.create!.id
  end
  User.create!(user)
end