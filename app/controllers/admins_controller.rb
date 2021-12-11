class AdminsController < ApplicationController
  before_action :is_admin, only: [:index, :associate]

  # GET /admins
  # GET /admins.json
  def index
    @admin = @current_user
  end

  def associate
    district_id = User.where(role: "Admin", id: @current_user.id)[0].district_id

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
      redirect_to admins_associate_page_path and return
    end
    parent.students << [student]
    flash[:notice] = 'Student and Parent successfully associated'

    redirect_to admins_associate_page_path and return
  end

  private

  def is_admin
    if @current_user.nil?
      # There is no logged in user
      flash[:warning] = "You must be logged in as an admin to access this page."
      redirect_to home_index_path
    else
      # The user is logged in
      unless @current_user.role == 'Admin'
        # The user is not a admin
        flash[:warning] = "You must be an admin to access this page."
        redirect_to home_index_path
      end
    end
  end
end
