require 'spec_helper'
require 'rails_helper'

describe Event do
  describe 'create_event_from_request' do
    before :each do
      student = User.find_by_email('studenta@gmail.com')
      @request = Request.new(
        med_name: 'Ibuprofen',
          time1: DateTime.now,
          time2: 2.hours.from_now,
          time3: 4.hours.from_now,
          time4: 6.hours.from_now,
          start_date: Date.today,
          end_date: 3.days.from_now,
          notes: 'Test Notes',
          parent_approved: true,
          nurse_approved: true,
          med_id: 12060,
          student_id: student.id,
          district_id: student.district_id
      )
    end
    it 'should create events with one dose' do
      request_1_dose = @request.deep_dup
      request_1_dose.daily_doses = '1'
      pre_events_amount = Event.all.length
      Event.create_event_from_request(request_1_dose)
      expect(Event.all.length).to be > pre_events_amount
    end
    it 'should create events with two doses' do
      request_2_dose = @request.deep_dup
      request_2_dose.daily_doses = '2'
      pre_events_amount = Event.all.length
      Event.create_event_from_request(request_2_dose)
      expect(Event.all.length).to be > pre_events_amount
    end
    it 'should create events with three doses' do
      request_3_dose = @request.deep_dup
      request_3_dose.daily_doses = '3'
      pre_events_amount = Event.all.length
      Event.create_event_from_request(request_3_dose)
      expect(Event.all.length).to be > pre_events_amount
    end
    it 'should create events with two doses' do
      request_4_dose = @request.deep_dup
      request_4_dose.daily_doses = '4'
      pre_events_amount = Event.all.length
      Event.create_event_from_request(request_4_dose)
      expect(Event.all.length).to be > pre_events_amount
    end
    it 'should check that a day is a weekend or not' do
      request_1_dose = @request.deep_dup
      request_1_dose.daily_doses = '1'
      expect(Event).to receive(:weekend?).at_least(:once)
      Event.create_event_from_request(request_1_dose)
    end
    it 'should call helper function create_event' do
      request_1_dose = @request.deep_dup
      request_1_dose.daily_doses = '1'
      expect(Event).to receive(:create_event).at_least(:once)
      Event.create_event_from_request(request_1_dose)
    end
  end
  describe 'weekend?' do
    it 'should return true if date is a weekend day' do
      expect(Event.weekend?(Date.today.next_week(:saturday))).to be_truthy
      expect(Event.weekend?(Date.today.next_week(:sunday))).to be_truthy
    end
    it 'should return false if date is a week day' do
      expect(Event.weekend?(Date.today.next_week(:monday))).to be_falsey
      expect(Event.weekend?(Date.today.next_week(:tuesday))).to be_falsey
      expect(Event.weekend?(Date.today.next_week(:wednesday))).to be_falsey
      expect(Event.weekend?(Date.today.next_week(:thursday))).to be_falsey
      expect(Event.weekend?(Date.today.next_week(:friday))).to be_falsey
    end
  end
  describe 'create_event' do
    before :all do
      student = User.find_by_email('studenta@gmail.com')
      @request = Request.new(
        med_name: 'Ibuprofen',
        time1: DateTime.now,
        time2: 2.hours.from_now,
        time3: 4.hours.from_now,
        time4: 6.hours.from_now,
        start_date: Date.today,
        end_date: 3.days.from_now,
        notes: 'Test Notes',
        parent_approved: true,
        nurse_approved: true,
        med_id: 12060,
        student_id: student.id,
        district_id: student.district_id
      )
    end
    it 'should add one event to the Event table' do
      time = Time.now
      amount_of_events = Event.all.length
      event = Event.create_event(@request, time)
      expect(Event.all.length).to eq(amount_of_events + 1)
      expect(event.time).to eq(time)
      expect(event.med_id).to eq(@request.med_id)
      expect(event.student_id).to eq(@request.student_id)
      expect(event.complete).to be_falsey
      expect(event.notes).to eq(@request.notes)
      expect(event.district).to eq(@request.district_id)
    end
  end
end