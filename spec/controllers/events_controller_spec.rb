require 'spec_helper'
require 'rails_helper'

describe EventsController do
  describe 'create an event' do
    it 'should redirect to login page if not logged in' do
      get :new, {}
      expect(response).to redirect_to(login_path)
    end
    it 'should display form if user is logged in' do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      get :new, {}
      expect(response).to render_template('new')
    end
    it 'should flash error message when med_id is empty' do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      post :create, event: { time: '2021-11-28 15:00:00', student_id: '1', med_id: '', complete: false, notes: '', district: '1' }
      expect(flash[:error]).to eq("Medication ID can't be empty")
      expect(response).to redirect_to(new_event_path)
    end
    it 'should create an event with current user district_id' do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      post :create, event: { time: '2021-11-28 15:00:00', student_id: '1', med_id: '1', complete: false, notes: '', district: '1' }
      expect(flash[:notice]).to eq('Event was successfully created.')
      expect(response).to redirect_to(events_path)
    end
  end
end