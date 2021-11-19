class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_filter :set_current_user
  protect_from_forgery with: :exception

  def set_current_user
    @current_user ||= User.find_by_session_token(session[:session_token])
  end
end
