class ParentsController < ApplicationController
  before_action :is_parent, only: [:index]

  # GET /parents
  # GET /parents.json
  def index
    if @current_user.nil? || @current_user.role != 'Parent'
      flash[:error] = 'Please login as a Parent.'
      redirect_to login_path
    else
      @parent = Parent.find(@current_user.role_id)
      @pending_requests = Array.new
      unless @parent.nil?
        @parent.students.each do |student|
          user = User.where(role_id: student.id, role: 'Student').first
          Request.where(student_id: user.id, parent_approved: false).each do |request|
            @pending_requests << request
          end
        end
      end
    end
  end

  private

  def is_parent
    if @current_user.nil?
      # There is no logged in user
      flash[:warning] = "You must be logged in as a parent to access this page."
      redirect_to home_index_path
    else
      # The user is logged in
      unless @current_user.role == 'Parent'
        # The user is not a parent
        flash[:warning] = "You must be a parent to access this page."
        redirect_to home_index_path
      end
    end
  end
end
