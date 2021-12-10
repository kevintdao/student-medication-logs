class AdminsController < ApplicationController
  before_action :is_admin, only: [:index]

  # GET /admins
  # GET /admins.json
  def index
    @admin = @current_user
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
