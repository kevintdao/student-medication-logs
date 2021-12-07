require 'spec_helper'
require 'rails_helper'

describe RequestsController do
  describe 'POST :create_request' do
    before :all do
      @student_request_params = {:request => {:med_name => 'Ibuprofen',
                                      :daily_doses => '1',
                                      :time1 => DateTime.now,
                                      :start_date => Date.today,
                                      :end_date => 2.days.from_now,
                                      :notes => 'Test Notes'}}
      @student = User.find_by_email('studenta@gmail.com')
      @parent = User.find_by_email('parent1a@gmail.com')
      @parent_request_params = @student_request_params.deep_dup
      @parent_request_params[:request][:student_id] = @student.id
    end
    it 'should redirect to the student dashboard and show success message when user is a Student' do
      login(@student)
      post :create_request, @student_request_params
      expect(response).to redirect_to(students_path)
      expect(flash[:notice]).to be_present
      expect(flash[:notice]).to eq('Request submitted for approval.')
    end
    it 'should redirect to the parent dashboard and show success message when user is a Parent' do
      login(@parent)
      post :create_request, @parent_request_params
      expect(response).to redirect_to(parents_path)
      expect(flash[:notice]).to be_present
      expect(flash[:notice]).to eq('Request submitted for approval.')
    end
    it 'should save a new request to the Request table in the database' do
      login(@student)
      old_request_amount = Request.all.length
      post :create_request, @student_request_params
      new_request_amount = Request.all.length
      expect(new_request_amount).to eq(old_request_amount + 1)
      expect(Request.where(requestor_id: @student.id)).to be_present
    end
    it 'should flash error message for empty medication name field' do
      login(@parent)
      no_med_name_params = @parent_request_params.deep_dup
      no_med_name_params[:request][:med_name] = ''
      post :create_request, no_med_name_params
      expect(response).not_to redirect_to(parents_path)
      expect(flash[:error]).to be_present
      expect(flash[:error]).to eq("Med name can't be blank")
    end
    it 'should flash error message for empty daily dose field' do
      login(@parent)
      no_daily_dose_params = @parent_request_params.deep_dup
      no_daily_dose_params[:request][:daily_doses] = ''
      post :create_request, no_daily_dose_params
      expect(response).not_to redirect_to(parents_path)
      expect(flash[:error]).to be_present
      expect(flash[:error]).to eq("Daily doses can't be blank")
    end
    it 'should flash error message for empty daily dose field' do
      login(@student)
      no_start_date_params = @student_request_params.deep_dup
      no_start_date_params[:request][:start_date] = ''
      post :create_request, no_start_date_params
      expect(response).not_to redirect_to(students_path)
      expect(flash[:error]).to be_present
      expect(flash[:error]).to eq("Start date can't be blank")
    end
    it 'should flash error message for empty daily dose field' do
      login(@student)
      no_end_date_params = @student_request_params.deep_dup
      no_end_date_params[:request][:end_date] = ''
      post :create_request, no_end_date_params
      expect(response).not_to redirect_to(students_path)
      expect(flash[:error]).to be_present
      expect(flash[:error]).to eq("End date can't be blank")
    end
    it 'should flash error message for empty student field for Parent' do
      login(@parent)
      no_student_params = @parent_request_params.deep_dup
      no_student_params[:request][:student_id] = ''
      post :create_request, no_student_params
      expect(response).not_to redirect_to(parents_path)
      expect(flash[:error]).to be_present
      expect(flash[:error]).to eq("Student can't be blank")
    end
  end
  describe "GET :index" do
    before :all do
      @student = User.find_by_email('studenta@gmail.com')
      @parent = User.find_by_email('parent1a@gmail.com')
      @nurse = User.find_by_email('nurse1@gmail.com')
    end
    it 'should have only that student pending requests when user is student' do
      login(@student)
      requests = Request.where('student_id = ? AND (parent_approved = ? OR nurse_approved = ?)', @student.id, false, false)
      get :index
      expect(response).to have_http_status(:ok)
      expect(assigns(:requests)).to eq(requests)
    end
    it "should make a parents children's requests visible when user is parent and they have not approved yet" do
      login(@parent)
      requests = Request.where(student_id: @student.id, parent_approved: false)
      get :index
      expect(response).to have_http_status(:ok)
      expect(assigns(:requests)).to eq(requests)
      expect(assigns(:user)).to eq(@student)
      expect(assigns(:parent)).to eq(Parent.find(@parent.role_id))
    end
    it "should make all requests in district visible when user is nurse and they have not approved yet" do
      login(@nurse)
      requests = Request.where(district_id: @nurse.district_id, nurse_approved: false)
      get :index
      expect(response).to have_http_status(:ok)
      expect(assigns(:requests)).to eq(requests)
    end
    it 'should redirect to login page if user is not logged in.' do
      get :index
      expect(response).to redirect_to login_path
      expect(flash[:error]).to be_present
      expect(flash[:error]).to eq('Please login with correct account.')
    end
  end
  describe 'GET :new' do
    before :all do
      @student = User.find_by_email('studenta@gmail.com')
      @parent = User.find_by_email('parent1a@gmail.com')
      @nurse = User.find_by_email('nurse1@gmail.com')
    end
    it 'should redirect to login page if user is not logged in.' do
      get :new
      expect(response).to redirect_to login_path
      expect(flash[:error]).to be_present
      expect(flash[:error]).to eq('Must be logged in.')
    end
    it 'should set a students variable for parents to choose their student from when user is parent' do
      login(@parent)
      students = User.where(role: 'Student', district_id: @parent.district_id)
      get :new
      expect(response).to have_http_status(:ok)
      expect(assigns(:students)).to eq(students)
    end
  end
  describe 'POST :approve' do
    before :all do
      @parent = User.find_by_email('parent1a@gmail.com')
      @nurse = User.find_by_email('nurse1@gmail.com')
      @approve_params_both_required = {:request_approve => { :id => Request.where(parent_approved: false, nurse_approved: false).first.id }}
      @approve_params_parent_required = {:request_approve => { :id => Request.where(parent_approved: false, nurse_approved: true).first.id }}
      @approve_params_nurse_required = {:request_approve => { :id => Request.where(parent_approved: true, nurse_approved: false).first.id }}
    end
    it 'should redirect to login page if user is not logged in' do
      post :approve, @approve_params_both_required
      expect(response).to redirect_to login_path
      expect(flash[:error]).to be_present
      expect(flash[:error]).to eq('Please login.')
    end
    it 'should update the request to be parent approved when user is parent' do
      login(@parent)
      request = Request.where(parent_approved: false, nurse_approved: false).first
      post :approve, @approve_params_both_required
      updated_request = Request.find(request.id)
      expect(updated_request.parent_approved).to be_truthy
      expect(updated_request.parent_approved).not_to eq(request.parent_approved)
      expect(updated_request.nurse_approved).to eq(request.nurse_approved)
    end
    it 'should update the request to be nurse approved when user is nurse' do
      login(@nurse)
      request = Request.where(parent_approved: false, nurse_approved: false).first
      post :approve, @approve_params_both_required
      updated_request = Request.find(request.id)
      expect(updated_request.nurse_approved).to be_truthy
      expect(updated_request.nurse_approved).not_to eq(request.nurse_approved)
      expect(updated_request.parent_approved).to eq(request.parent_approved)
    end
    it 'should not call method to update Events table when parent is first to approve' do
      login(@parent)
      expect(Event).not_to receive(:create_event_from_request).with(:request)
      post :approve, @approve_params_both_required
    end
    it 'should call method to update Events table when parent is second to approve' do
      login(@parent)
      request = Request.where(parent_approved: false, nurse_approved: true).first
      expect(Event).to receive(:create_event_from_request).with(request)
      post :approve, @approve_params_parent_required
    end
    it 'should flash a success message that medication events were created when user is second to approve' do
      login(@parent)
      request = Request.where(parent_approved: false, nurse_approved: true).first
      allow(Event).to receive(:create_event_from_request).with(request)
      post :approve, @approve_params_parent_required
      expect(flash[:notice]).to be_present
      expect(flash[:notice]).to eq('Successfully approved. Medication Events have been created.')
    end
    it 'should flash a success message that the request was approved when user is first to approve' do
      login(@nurse)
      post :approve, @approve_params_both_required
      expect(flash[:notice]).to be_present
      expect(flash[:notice]).to eq('Successfully approved.')
    end
    it 'should redirect to requests page if user logged in' do
      login(@nurse)
      post :approve, @approve_params_both_required
      expect(response).to redirect_to requests_path
    end
    it 'should set request to be the request with the id of the input' do
      login(@parent)
      request = Request.where(parent_approved: false, nurse_approved: false).first
      post :approve, @approve_params_both_required
      expect(assigns(:request)).to eq(request)
    end
  end
end