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

  def update
    @user = User.find_by_password_set_token!(params[:id])
    if @user.password_set_sent_at < 2.day.ago
      flash[:notice] = 'Password set has expired'
      redirect_to new_password_sets_path
    elsif @user.update(user_params)
      flash[:notice] = 'Password has been set!'
      redirect_to users_login_path
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:password)
  end
end
