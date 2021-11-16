class PasswordSetsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    user&.send_password_set
    flash[:notice] = 'Email sent with password reset instructions.'
    redirect_to users_login_path
  end

  def edit
    @user = User.find_by_password_set_token!(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:password)
  end
end
