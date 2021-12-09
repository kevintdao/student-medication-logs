class RequestsController < ApplicationController
  before_action :set_request, only: [:show, :edit, :update, :destroy]

  # GET /requests
  # GET /requests.json
  def index
    if @current_user.nil?
      flash[:error] = 'Please login with correct account.'
      redirect_to login_path
    else
      case @current_user.role
      when 'Student'
        @requests = Request.where('student_id = ? AND (parent_approved = ? OR nurse_approved = ?)', @current_user.id, false, false)
      when 'Parent'
        @parent = Parent.find(@current_user.role_id)
        @requests = Array.new
        @parent.students.each do |student|
          @user = User.where(role_id: student.id, role: 'Student').first
          Request.where(student_id: @user.id, parent_approved: false).to_a.each do |request|
            @requests << request
          end
        end
      when 'Nurse'
        @requests = Request.where(district_id: @current_user.district_id, nurse_approved: false)
      end
    end

  end

  # GET /requests/new
  def new
    if @current_user.nil?
      flash[:error] = 'Must be logged in.'
      redirect_to login_path
    elsif @current_user.role == 'Parent'
      @students = User.where(role: 'Student', district_id: @current_user.district_id)
    end
    @request = Request.new
  end

  def approve
    if @current_user.nil?
      flash[:error] = 'Please login.'
      redirect_to login_path
    else
      @request = Request.find(params[:request_approve][:id])
      case @current_user.role
      when 'Parent'
        @request.update!(parent_approved: true)
      when 'Nurse'
        @request.update!(nurse_approved: true)
      end
      if @request.parent_approved && @request.nurse_approved
        Event.create_event_from_request(@request)
        flash[:notice] = 'Successfully approved. Medication Events have been created.'
      else
        flash[:notice] = 'Successfully approved.'
      end
      redirect_to requests_path
    end
  end

  def create_request
    @request = params[:request]
    @new_request = Request.new(
      requestor_id: @current_user.id,
      daily_doses: @request[:daily_doses],
      start_date: @request[:start_date],
      end_date: @request[:end_date],
      nurse_approved: false,
      notes: @request[:notes],
      district_id: @current_user.district_id,
      med_name: @request[:med_name]
    )
    case @current_user.role
    when 'Parent'
      @new_request.student_id = @request[:student_id]
      @new_request.parent_approved = true
    when 'Student'
      @new_request.student_id = @current_user.id
      @new_request.parent_approved = false
    end
    @new_request.time1 = @request[:time1]
    @new_request.time2 = @request[:time2] if @new_request.daily_doses.to_i >= 2
    @new_request.time3 = @request[:time3] if @new_request.daily_doses.to_i >= 3
    @new_request.time4 = @request[:time4] if @new_request.daily_doses.to_i >= 4
    @medication = Medication.where(brand_name: @new_request.med_name.upcase).first
    unless @medication.nil?
      @new_request.med_id = @medication.id
    end
    if !@new_request.valid?
      error_message = @new_request.errors.full_messages[0]
      flash[:error] = error_message
      redirect_to new_request_path
    else
      @new_request.save!
      flash[:notice] = 'Request submitted for approval.'
      case @current_user.role
      when 'Parent'
        redirect_to parents_path
      when 'Student'
        redirect_to students_path
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_request
      @request = Request.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def request_params
      params.require(:request).permit(:time1, :time2, :time3, :time4, :daily_doses, :start_date, :end_date, :student_id, :requestor_id, :med_id, :district_id, :notes, :parent_approved, :nurse_approved)
    end
end
