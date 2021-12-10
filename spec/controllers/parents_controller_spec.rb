require 'spec_helper'
require 'rails_helper'

describe ParentsController do
  describe 'GET :index' do
    before :all do
      @parent_u = User.find_by_email('parent1a@gmail.com')
      @parent_p = Parent.find(@parent_u.role_id)
    end
    it 'should redirect to login if user is not logged in' do
      get :index
      expect(response).to redirect_to login_path
      expect(flash[:error]).to be_present
      expect(flash[:error]).to eq('Please login as a Parent.')
    end
    it 'should redirect to login if not a parent' do
      login(User.find_by_email('studenta@gmail.com'))
      get :index
      expect(response).to redirect_to login_path
      expect(flash[:error]).to be_present
      expect(flash[:error]).to eq('Please login as a Parent.')
    end
    it 'should set parent variable to Parent model object' do
      login(@parent_u)
      get :index
      expect(response).to have_http_status(:ok)
      expect(assigns(:parent)).to eq(@parent_p)
    end
    it 'should have pending requests be empty if parent has no students' do
      login(User.find_by_email('parent2@gmail.com'))
      get :index
      expect(response).to have_http_status(:ok)
      expect(assigns(:pending_requests)).to eq([])
    end
    it "should have pending requests equal the requests parent's student has made that parent has not approved" do
      login(@parent_u)
      student = User.find_by_email('studenta@gmail.com')
      requests = Request.where(student_id: student.id, parent_approved: false)
      get :index
      expect(response).to have_http_status(:ok)
      expect(assigns(:pending_requests)).to eq(requests)
    end
  end
end