require 'spec_helper'
require 'rails_helper'

describe RequestsController do
  describe 'creating a request as a student or parent' do
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

end