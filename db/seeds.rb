# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

districts = [{}]

users = [
  { email: 'admin@gmail.com', first_name: 'Default', last_name: 'Admin', password: '123456', password_confirmation: '123456', role: 'Admin', role_id: 1, district_id: 1 },
  { email: 'nurse1@gmail.com', first_name: 'Nurse', last_name: '1', password: '123456', password_confirmation: '123456', role: 'Nurse', role_id: 2, district_id: 1},
  { email: 'parent1@gmail.com', first_name: 'Parent', last_name: '1', password: '123456', password_confirmation: '123456', role: 'Parent', role_id: 3, district_id: 1},
  { email: 'student1@gmail.com', first_name: 'Student', last_name: '1', password: '123456', password_confirmation: '123456', role: 'Student', role_id: 4, district_id: 1},
  { email: 'nurse2@gmail.com', first_name: 'Nurse', last_name: '2', password: '123456', password_confirmation: '123456', role: 'Nurse', role_id: 2, district_id: 2},
  { email: 'parent2@gmail.com', first_name: 'Parent', last_name: '2', password: '123456', password_confirmation: '123456', role: 'Parent', role_id: 3, district_id: 2},
  { email: 'student2@gmail.com', first_name: 'Student', last_name: '2', password: '123456', password_confirmation: '123456', role: 'Student', role_id: 4, district_id: 2}
]

users.each do |user|
  User.create!(user)
end
