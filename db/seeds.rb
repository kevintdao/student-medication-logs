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
