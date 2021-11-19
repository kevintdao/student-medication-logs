class SessionsController < ApplicationController
  require 'bcrypt'
  skip_before_filter :set_current_user
  def new

  end

  def create
    if(params[:email][:email].blank?)
      flash[:notice] = "Invalid email"
      redirect_to users_login_path
    elsif(params[:password][:password].blank?)

      flash[:notice] = "Invalid password"
      redirect_to users_login_path
    else
      decrypt_password = BCrypt::Password.create(params[:password][:password])
      email = params[:email][:email]
      if(User.where(:email => email).where(:password_digest => decrypt_password))
        flash[:notice] = "login successful"
        # session_token = SecureRandom.urlsafe_base64
        # User.where(:email => email).where(:password_digest => decrypt_password).session_token = session_token
        # User.save!
        # session[:session_token] = session_token
        session[:session_token] = User.where(:email => email).where(:password_digest => decrypt_password).session_token
        redirect_to home_index_path
      else
        flash[:notice] = "There is no user with this email/password"
        redirect_to users_login_path
      end
    end
  end

  def destroy
    reset_session
  end
end
#   def create
#     user = User.find_by_email(params[:session][:email])
#     if user && user.authenticate(params[:session][:password])
#       session[:session_token] = user.session_token
#       @current_user = user
#       redirect_to home_index_path
#     else
#       flash.now[:warning] = "Invalid email/password combination"
#       redirect_to users_login_path
#     end
#   end
#   def destroy
#     session.delete(:session_token)
#     flash[:notice] = "logged out successfully"
#     redirect_to home_index_path
#   end
# end