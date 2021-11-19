class SessionsController < ApplicationController
  skip_before_filter :set_current_user

  def new
  end

  def create
    email = params[:email][:email]
    password = params[:password][:password]

    if email.blank? || password.blank?
      flash[:error] = 'Email and/or password field are blank'
      redirect_to login_path and return
    elsif User.where(email: email).empty?
      flash[:error] = 'Invalid email/password combination'
      redirect_to login_path and return
    else
      stored_password = BCrypt::Password.new(User.find_by(email: email).password_digest)
      if stored_password != password
        flash[:error] = 'Invalid email/password combination'
        redirect_to login_path and return
      else
        session_token = User.find_by(email: email).session_token
        session[:session_token] = session_token
        flash[:notice] = "Successfully login! You are logged in as #{email}"
      end
    end
    redirect_to users_path
  end

  def destroy
    session[:session_token] = nil
    flash[:notice] = 'Logged out'
    redirect_to login_path
  end
end