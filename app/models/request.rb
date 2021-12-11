class Request < ActiveRecord::Base
  validates :daily_doses, presence: true
  validates :med_name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :student_id, presence: true
  validates :amount, presence: true
end
