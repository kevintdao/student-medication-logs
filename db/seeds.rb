# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'

 csv_text = File.read(Rails.root.join('lib', 'seeds', 'drugs.csv'))
 csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')

 csv.each do |row|
   m = Medication.new
   m.brand_name = row['DrugName']
   m.active_ing = row['ActiveIngredient']
   m.method = row['Form']
   m.strength = row['Strength']
   m.save
 end

puts "There are now #{Medication.count} rows in the medications table"

events = [{time: DateTime.new(2021, 12, 15, 15, 0, 0), student_id: 1, med_id: 35, complete: false, notes: "This is a notes field for this event.", district: 1},
          {time: DateTime.new(2021, 12, 14, 12, 0, 0), student_id: 2, med_id: 32, complete: false},
          {time: DateTime.new(2021, 12, 1, 9, 45, 0), student_id: 3, med_id: 400, complete: false, notes: "Here is a note for this event", district: 2},
          {time: DateTime.new(2021, 12, 5, 14, 30, 0), student_id: 1, med_id: 345, complete: false, notes: "Notes go into this field", district: 1},
          {time: DateTime.new(2021, 12, 10, 8, 0, 0), student_id: 4, med_id: 554, complete: true, notes: "This is an example of a completed event"}, district: 1]

events.each do |user|
  Event.create!(user)
end

puts "There are now #{Event.count} rows in the events table"

csv_text = File.read(Rails.root.join('lib', 'seeds', 'events.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')

csv.each do |row|
  m = Event.new
  m.student_id = row['StudentID']
  m.nurse_id = row['NurseID']
  m.med_id = row['MedicationID']
  m.start_time = row['StartTime']
  m.end_time = row['EndTime']
  m.notes = row['Notes']
  m.completed = row['Completed']
  m.save
end

districts = [{}]

users = [
  { email: 'admin1@gmail.com', first_name: 'Admin', last_name: '1', password: '123456', password_confirmation: '123456', role: 'Admin', role_id: 1, district_id: 1 },
  { email: 'nurse1@gmail.com', first_name: 'Nurse', last_name: '1', password: '123456', password_confirmation: '123456', role: 'Nurse', role_id: 2, district_id: 1 },
  { email: 'parent1a@gmail.com', first_name: 'Parent', last_name: '1A', password: '123456', password_confirmation: '123456', role: 'Parent', role_id: 3, district_id: 1 },
  { email: 'parent1b@gmail.com', first_name: 'Parent', last_name: '1B', password: '123456', password_confirmation: '123456', role: 'Parent', role_id: 3, district_id: 1 },
  { email: 'studenta@gmail.com', first_name: 'Student', last_name: 'A', password: '123456', password_confirmation: '123456', role: 'Student', role_id: 4, district_id: 1 },
  { email: 'studentb@gmail.com', first_name: 'Student', last_name: 'B', password: '123456', password_confirmation: '123456', role: 'Student', role_id: 4, district_id: 1 },
  { email: 'studentc@gmail.com', first_name: 'Student', last_name: 'C', password: '123456', password_confirmation: '123456', role: 'Student', role_id: 4, district_id: 1 },
  { email: 'admin2@gmail.com', first_name: 'Admin', last_name: '2', password: '123456', password_confirmation: '123456', role: 'Admin', role_id: 1, district_id: 2 },
  { email: 'nurse2@gmail.com', first_name: 'Nurse', last_name: '2', password: '123456', password_confirmation: '123456', role: 'Nurse', role_id: 2, district_id: 2 },
  { email: 'parent2@gmail.com', first_name: 'Parent', last_name: '2', password: '123456', password_confirmation: '123456', role: 'Parent', role_id: 3, district_id: 2 },
  { email: 'student2@gmail.com', first_name: 'Student', last_name: '2', password: '123456', password_confirmation: '123456', role: 'Student', role_id: 4, district_id: 2 }
]

users.each do |user|
  User.create!(user)
end