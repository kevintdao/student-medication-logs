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

