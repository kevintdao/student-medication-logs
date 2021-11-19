class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_filter :set_current_user
  protect_from_forgery with: :exception
  def index; end

  def set_current_user
    @current_user ||= User.where(:id=> session[:user_id])
    redirect_to users_login_path and return unless @current_user
  end
end
