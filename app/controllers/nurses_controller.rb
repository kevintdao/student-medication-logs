class NursesController < ApplicationController
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
end

