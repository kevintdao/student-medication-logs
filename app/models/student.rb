class Student < ActiveRecord::Base
  has_and_belongs_to_many :parents
  has_many :medications
  has_many :events
end
