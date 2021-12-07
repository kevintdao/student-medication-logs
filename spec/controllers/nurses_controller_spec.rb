require 'spec_helper'
require 'rails_helper'

describe NursesController do
  describe 'GET :index' do
    before :all do
      @nurse = User.find_by_email('nurse1@gmail.com')
    end
    it 'should redirect to login if user is not logged in' do
      get :index
      expect(response).to redirect_to login_path
      expect(flash[:error]).to be_present
      expect(flash[:error]).to eq('Please login as a Nurse.')
    end
    it 'should redirect to login if not a nurse' do
      login(User.find_by_email('studenta@gmail.com'))
      get :index
      expect(response).to redirect_to login_path
      expect(flash[:error]).to be_present
      expect(flash[:error]).to eq('Please login as a Nurse.')
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
    it "should have pending requests equal the requests for district that nurse has not approved" do
      login(@nurse)
      requests = Request.where(district_id: @nurse.district_id, nurse_approved: false)
      get :index
      expect(response).to have_http_status(:ok)
      expect(assigns(:pending_requests)).to eq(requests)
    end
    it 'should clear the session search_term value after action' do
      request.session[:search_term] = 'test search'
      get :index
      expect(request.session[:search_term]).to be_nil
    end
  end

end