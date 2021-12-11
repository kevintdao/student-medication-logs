class NursesController < ApplicationController
  before_action :is_nurse, only: [:index]
  after_action :clear_search


  # GET /nurses
  # GET /nurses.json
  def index
    if @current_user.nil? || @current_user.role != 'Nurse'
      flash[:error] = 'Please login as a Nurse.'
      redirect_to login_path
    else
      @nurse = @current_user
      @pending_requests = Array.new
      @pending_requests = Request.where(district_id: @nurse.district_id, nurse_approved: false)
    end
  end

  def clear_search
    session[:search_term] = nil
  end

  def associate
    district_id = User.where(role: "Nurse", role_id: @current_user.id)[0].district_id

    @parents = User.where(district_id: district_id, role: "Parent")
    @parents_info = []
    @parents.each do |x|
      @parents_info.push([x.first_name + " " + x.last_name, x.role_id])
    end
    @students_info = []
    @students = User.where(district_id: district_id, role: "Student")
    @students.each do |x|
      @students_info.push([x.first_name + " " + x.last_name, x.role_id])
    end
  end

  def associatestudentparent
    parent_info = params[:parent]
    parent_id = parent_info
    parent = Parent.find(parent_id)

    student_info = params[:student]
    student_id = student_info
    student = Student.find(student_id)

    if student.in?(parent.students)
      flash[:notice] = 'Student and Parent are already associated'
      redirect_to nurses_associate_page_path and return
    end
    parent.students << [student]
    flash[:notice] = 'Student and Parent successfully associated'

    redirect_to nurses_associate_page_path and return
  end

  private

  def is_nurse
    if @current_user.nil?
      # There is no logged in user
      flash[:warning] = "You must be logged in as a nurse to access this page."
      redirect_to home_index_path
    else
      # The user is logged in
      unless @current_user.role == 'Nurse'
        # The user is not a nurse
        flash[:warning] = "You must be a registered nurse to access this page."
        redirect_to home_index_path
      end
    end
  end
end

