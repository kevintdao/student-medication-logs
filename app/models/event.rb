class Event < ActiveRecord::Base
  belongs_to :student

  def self.create_event_from_request(request)
    start = request.start_date
    end_date = request.end_date
    Date.new(start.year, start.month, start.day).upto(Date.new(end_date.year, end_date.month, end_date.day)) do |day|
      current_dose = 1
      unless weekend?(day)
        request.daily_doses.to_i.times do
          case current_dose
          when 1
            create_event(request, DateTime.new(day.year, day.month, day.day, request.time1.hour, request.time1.min, 0))
          when 2
            create_event(request, DateTime.new(day.year, day.month, day.day, request.time2.hour, request.time2.min, 0))
          when 3
            create_event(request, DateTime.new(day.year, day.month, day.day, request.time3.hour, request.time3.min, 0))
          when 4
            create_event(request, DateTime.new(day.year, day.month, day.day, request.time3.hour, request.time3.min, 0))
          end
          current_dose += 1
        end
      end
    end
  end


  def self.weekend?(day)
    (day.wday == 0 || day.wday == 6)
  end

  def self.create_event(request, time)
    Event.create!(time: time, student_id: request.student_id, med_id: request.med_id, complete: false, notes: request.notes, district: request.district_id)
  end
end
