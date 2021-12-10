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

events = [
  {time: DateTime.new(2021, 12, 15, 15, 0, 0), student_id: 5, med_id: 415, complete: false, notes: "This is a notes field for this event.", district: 1, amount: 1},
  {time: DateTime.new(2021, 12, 14, 12, 0, 0), student_id: 6, med_id: 34, complete: false, district: 1, amount: 2},
  {time: DateTime.new(2021, 12, 1, 9, 45, 0), student_id: 11, med_id: 1234, complete: false, notes: "Here is a note for this event", district: 2, amount: 1},
  {time: DateTime.new(2021, 12, 5, 14, 30, 0), student_id: 5, med_id: 400, complete: false, notes: "Notes go into this field", district: 1, amount: 1},
  {time: DateTime.new(2021, 12, 10, 8, 0, 0), student_id: 7, med_id: 6087, complete: true, notes: "This is an example of a completed event", district: 1, amount: 1}
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

inventory = [
  {med_id: 34, amount: 50, studentID: 6, districtID: 1, notes: "These are notes for this medication", medName: Medication.where(id: 34).first.brand_name},
  {med_id: 415, amount: 10, studentID: 5, districtID: 1, notes: nil, medName: Medication.where(id: 415).first.brand_name},
  {med_id: 400, amount: 20, studentID: nil, districtID: 1, notes: nil, medName: Medication.where(id: 400).first.brand_name},
  {med_id: 1064, amount: 1, studentID: 5, districtID: 1, notes: "Some more notes can go here", medName: Medication.where(id: 1064).first.brand_name},
  {med_id: 6087, amount: 100, studentID: 7, districtID: 1, notes: "This is a medication for district 1", medName: Medication.where(id: 6087).first.brand_name},
  {med_id: 1234, amount: 20, studentID: 11, districtID: 2, notes: "This is a medication for district 2", medName: Medication.where(id: 1234).first.brand_name}
]

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

# create one parent/student relationship
student = Student.find(User.where(email: 'studenta@gmail.com')[0].role_id)
parent = Parent.find(User.where(email: 'parent1a@gmail.com')[0].role_id)
parent.students = [student]
student.parents = [parent]
student.save!
parent.save!

student_user = User.find_by_email('studenta@gmail.com')
parent_user = User.find_by_email('parent1a@gmail.com')
requests = [
  {time1: DateTime.now, time2: 2.hours.from_now, time3: nil, time4:nil, daily_doses: '2', start_date: 5.days.from_now, end_date: 15.days.from_now, student_id: student_user.id, requestor_id: student_user.id, med_id: 130, district_id: student_user.district_id, notes: 'Please give me this medication.', parent_approved: false, nurse_approved: false, med_name: 'Benadryl'  },
  {time1: DateTime.now, time2: 2.hours.from_now, time3: 4.hours.from_now, time4:nil, daily_doses: '3', start_date: 5.days.from_now, end_date: 25.days.from_now, student_id: student_user.id, requestor_id: parent_user.id, med_id: 130, district_id: parent_user.district_id, notes: 'Please give my child this medication.', parent_approved: true, nurse_approved: false, med_name: 'Ibuprofen'  },
  {time1: DateTime.now, time2: 2.hours.from_now, time3: 4.hours.from_now, time4: 6.hours.from_now, daily_doses: '4', start_date: 5.days.from_now, end_date: 25.days.from_now, student_id: student_user.id, requestor_id: student_user.id, med_id: 1, district_id: parent_user.district_id, notes: 'Please give my child this medication.', parent_approved: false, nurse_approved: true, med_name: 'PAREDRINE'  }
]

requests.each do |request|
  Request.create!(request)
end

forms = [{studentID: 5, parent_approved: false, nurse_approved: true, body: "This is a seeded entry 1", districtID: 1},
         {studentID: 6, parent_approved: false, nurse_approved: true, body: "This is a seeded entry 2", districtID: 1},
         {studentID: 7, parent_approved: true, nurse_approved: false, body: "This is a seeded entry 3", districtID: 1},
         {studentID: 5, parent_approved: true, nurse_approved: true, body: "This is a seeded entry 4", districtID: 2},]

forms.each do |item|
  Form.create!(item)
end

puts "There are now #{Form.count} rows in the forms table"

students = [{medications_id: nil, events_id: nil, year: "Junior", parents_id: nil},
            {medications_id: nil, events_id: nil, year: "Junior", parents_id: nil},
            {medications_id: nil, events_id: nil, year: "Junior", parents_id: nil},
            {medications_id: nil, events_id: nil, year: "Junior", parents_id: nil},
            {medications_id: nil, events_id: nil, year: "Junior", parents_id: nil},
            {medications_id: nil, events_id: nil, year: "Junior", parents_id: nil},
            {medications_id: nil, events_id: nil, year: "Junior", parents_id: nil},
            {medications_id: nil, events_id: nil, year: "Junior", parents_id: nil},]

students.each do |student|
  Student.create!(student)
end

puts "There are now #{Student.count} rows in the students table"

parents = [{student_ids: [5,7]}, {student_ids: [5]}, {student_ids: [7]}, {student_ids: [5,6,7]}]

parents.each do |parent|
  Parent.create!(parent)
end
