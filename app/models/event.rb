class Event < ActiveRecord::Base
  belongs_to :student

  def self.create_event_from_request(request)

  end

end
