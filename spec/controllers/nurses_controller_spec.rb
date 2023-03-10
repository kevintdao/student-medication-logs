require 'spec_helper'
require 'rails_helper'

describe NursesController do
  describe 'GET :index' do
    before :all do
      @nurse = User.find_by_email('nurse1@gmail.com')
    end
    it 'returns http success' do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      get :index
      expect(response).to have_http_status(:success)
    end
    it 'should redirect to login if user is not logged in' do
      get :index
      expect(response).to redirect_to home_index_path
      expect(flash[:warning]).to be_present
      expect(flash[:warning]).to eq('You must be logged in as a nurse to access this page.')
    end
    it 'should redirect to login if not a nurse' do
      login(User.find_by_email('studenta@gmail.com'))
      get :index
      expect(response).to redirect_to home_index_path
      expect(flash[:warning]).to be_present
      expect(flash[:warning]).to eq('You must be a registered nurse to access this page.')
    end
    it 'should set nurse variable to Nurse model object' do
      login(@nurse)
      get :index
      expect(response).to have_http_status(:ok)
      expect(assigns(:nurse)).to eq(@nurse)
    end
    it 'should have no pending requests if nurse has no requests' do
      login(User.find_by_email('nurse2@gmail.com'))
      get :index
      expect(response).to have_http_status(:ok)
      expect(assigns(:pending_requests)).to eq([])
    end
    it 'should have pending requests equal the requests for district that nurse has not approved' do
      login(@nurse)
      requests = Request.where(district_id: @nurse.district_id, nurse_approved: false)
      get :index
      expect(response).to have_http_status(:ok)
      expect(assigns(:pending_requests)).to eq(requests)
    end
  end
  describe 'associate student and parent' do
    it 'should correctly associate student and parent' do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      post :associatestudentparent, student: "1", parent: "2"
      expect(response).to redirect_to(nurses_associate_page_path)
      expect(flash[:notice]).to be_present
      expect(flash[:notice]).to eq('Student and Parent successfully associated')
    end
    it 'should indicate when student and parent are already associated' do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      post :associatestudentparent, student: "1", parent: "1"
      expect(response).to redirect_to(nurses_associate_page_path)
      expect(flash[:notice]).to be_present
      expect(flash[:notice]).to eq('Student and Parent are already associated')
    end
    it 'show students and parents correctly' do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com')[0])
      get :associate
      expect(response).to have_http_status(:ok)
    end
  end
end