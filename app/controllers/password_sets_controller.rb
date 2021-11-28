class PasswordSetsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    user&.send_password_set
    flash[:notice] = 'Email sent with password set instructions.'
    redirect_to home_index_path
  end

  def edit
    @user = User.find_by_password_set_token!(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:password)
  end
end
