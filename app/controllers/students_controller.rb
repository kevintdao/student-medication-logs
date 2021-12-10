class StudentsController < ApplicationController
  before_action :is_student, only: [:index]

  # GET /students
  # GET /students.json
  def index
    @student = @current_user
  end

  private

  def is_student
    if @current_user.nil?
      # There is no logged in user
      flash[:warning] = "You must be logged in as a student to access this page."
      redirect_to home_index_path
    else
      # The user is logged in
      unless @current_user.role == 'Student'
        # The user is not a student
        flash[:warning] = "You must be a student to access this page."
        redirect_to home_index_path
      end
    end
  end
end
