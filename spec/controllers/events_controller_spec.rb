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

  describe "GET /index" do
    it "returns http success" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      get :index
      expect(response).to have_http_status(:success)
    end
    it "properly reads the session" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      allow_any_instance_of(EventsController).to receive(:session) {{"page_count": 25, "search_term": "Ibuprofen"}}
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:pages)).to eq(25)
      expect(assigns(:selection)).to eq("Ibuprofen")
    end
    it "loads when pages and the search term are nil" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:events)).not_to eq(nil)
    end
    it "loads when pages and the search term are not nil" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      allow_any_instance_of(EventsController).to receive(:session) {{"page_count": 25, "search_term": "Ibuprofen"}}
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:events)).not_to eq(nil)
    end
    it "loads when pages are nil and search term is not" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      allow_any_instance_of(EventsController).to receive(:session) {{"search_term": "Ibuprofen"}}
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:events)).not_to eq(nil)
    end
    it "loads when pages are not nil and search term is" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      allow_any_instance_of(EventsController).to receive(:session) {{"page_count": 25}}
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:events)).not_to eq(nil)
    end
  end
  describe "GET /past_events" do
    it "returns http success" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      get :past_events
      expect(response).to have_http_status(:success)
    end
    it "properly reads the session" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      allow_any_instance_of(EventsController).to receive(:session) {{"page_count": 25, "search_term": "Ibuprofen"}}
      get :past_events
      expect(response).to have_http_status(:success)
      expect(assigns(:pages)).to eq(25)
      expect(assigns(:selection)).to eq("Ibuprofen")
    end
    it "loads when pages and the search term are nil" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      get :past_events
      expect(response).to have_http_status(:success)
      expect(assigns(:events)).not_to eq(nil)
    end
    it "loads when pages and the search term are not nil" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      allow_any_instance_of(EventsController).to receive(:session) {{"page_count": 25, "search_term": "Ibuprofen"}}
      get :past_events
      expect(response).to have_http_status(:success)
      expect(assigns(:events)).not_to eq(nil)
    end
    it "loads when pages are nil and search term is not" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      allow_any_instance_of(EventsController).to receive(:session) {{"search_term": "Ibuprofen"}}
      get :past_events
      expect(response).to have_http_status(:success)
      expect(assigns(:events)).not_to eq(nil)
    end
    it "loads when pages are not nil and search term is" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      allow_any_instance_of(EventsController).to receive(:session) {{"page_count": 25}}
      get :past_events
      expect(response).to have_http_status(:success)
      expect(assigns(:events)).not_to eq(nil)
    end
  end
  describe "POST /set_page_count" do
    it "redirects to event path" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      post :set_page_count
      expect(response).to redirect_to(events_path)
    end
    it "sets the pages from the params" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      post :set_page_count, page_count: {page_count: 25}
      expect(assigns(:pages)).to eq("25")
      expect(response).to redirect_to(events_path)
    end
    it "sets the session correctly" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      post :set_page_count, page_count: {page_count: 25}
      expect(session[:page_count]).to eq(25)
      expect(response).to redirect_to(events_path)
    end
  end
  describe "POST /search_events" do
    it "redirects to events_path" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      post :search_events
      expect(response).to redirect_to(events_path)
    end
    it "sets the session correctly" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      post :search_events, search_term: {search_term: "FName"}
      expect(session[:search_term]).to eq("FName")
      expect(response).to redirect_to(events_path)
    end
  end
  describe "POST /set_past_page_count" do
    it "redirects to past events path" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      post :set_past_page_count
      expect(response).to redirect_to(events_past_events_path)
    end
    it "sets the pages from the params" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      post :set_past_page_count, page_count: {page_count: 25}
      expect(assigns(:pages)).to eq("25")
      expect(response).to redirect_to(events_past_events_path)
    end
    it "sets the session correctly" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      post :set_past_page_count, page_count: {page_count: 25}
      expect(session[:page_count]).to eq(25)
      expect(response).to redirect_to(events_past_events_path)
    end
  end
  describe "POST /search_past_events" do
    it "redirects to past_events_path" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      post :search_past_events
      expect(response).to redirect_to(events_past_events_path)
    end
    it "sets the session correctly" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      post :search_past_events, search_term: {search_term: "FName"}
      expect(session[:search_term]).to eq("FName")
      expect(response).to redirect_to(events_past_events_path)
    end
  end
  describe "GET events/complete" do
    it "redirects to past_events_path" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      get :complete
      expect(response).to redirect_to(events_past_events_path)
    end
    it "creates an error message when the params are nil" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      get :complete
      expect(flash[:error]).to eq("There was a problem marking this event as complete")
      expect(response).to redirect_to(events_past_events_path)
    end
    it "creates a success message when the params are not nil" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      get :complete, id:1
      expect(assigns(:eventID)).to eq("1")
      expect(flash[:notice]).to eq("Event has been marked as complete")
      expect(response).to redirect_to(events_past_events_path)
    end
  end
  describe "GET events/incomplete" do
    it "redirects to events_path" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      get :complete
      expect(response).to redirect_to(events_past_events_path)
    end
    it "creates an error message when the params are nil" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      get :incomplete
      expect(flash[:error]).to eq("There was a problem marking this event as incomplete")
      expect(response).to redirect_to(events_path)
    end
    it "creates a success message when the params are not nil" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      get :incomplete, id:1
      expect(assigns(:eventID)).to eq("1")
      expect(flash[:notice]).to eq("Event has been marked as incomplete")
      expect(response).to redirect_to(events_path)
    end
  end
  describe "POST events/change_notes" do
    it "should redirect to events_path by default" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      post :change_notes
      expect(response).to redirect_to(events_path)
    end
    it "should set instance variables correctly" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      post :change_notes, notes: {notes: "This is a new note", id: -1, complete: false}
      expect(assigns(:newNotes)).to eq("This is a new note")
      expect(assigns(:id)).to eq("-1")
      expect(assigns(:complete)).to eq(false)
      expect(flash[:notice]).to eq("Notes have been updated successfully")
    end
    it "should redirect to events_past_events_path when the event is complete" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      post :change_notes, notes: {notes: "This is a new note", id: -1, complete: true}
      expect(response).to redirect_to(events_path)
    end
  end
end