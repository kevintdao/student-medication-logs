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

puts "There are now #{Medication.count} rows in the transactions table"

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