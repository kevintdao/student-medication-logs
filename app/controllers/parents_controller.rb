class ParentsController < ApplicationController
  before_action :set_parent, only: [:show, :edit, :update, :destroy]

  # GET /parents
  # GET /parents.json
  def index
    if @current_user.nil? || @current_user.role != 'Parent'
      flash[:error] = 'Please login as a Parent.'
      redirect_to login_path
    else
      @parent = Parent.find(@current_user.role_id)
      @pending_requests = Array.new
      @pending_forms = Array.new
      unless @parent.nil?
        @parent.students.each do |student|
          user = User.where(role_id: student.id, role: 'Student').first
          Request.where(student_id: user.id, parent_approved: false).each do |request|
            @pending_requests << request
          end
          Form.where(studentID: user.id, parent_approved: false).each do |form|
            @pending_forms << form
          end
        end
      end
    end
  end

end
