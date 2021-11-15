class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    if params[:search_term].present?
      name = params[:search_term][:search_term]
      if name.present?
        @users = User.where('lower(first_name) = ?', name.downcase)
        return @users
      end
    end
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show; end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit; end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def register; end

  def register_district_admin
    @register = params[:register]
    @user = User.new(
      first_name: @register[:first_name],
      last_name: @register[:last_name],
      email: @register[:email],
      role: 'Admin',
      password: @register[:password],
      password_confirmation: @register[:password_confirmation]
    )
    if !@user.valid?
      error_message = @user.errors.full_messages[0]
      flash[:error] = error_message
      redirect_to users_register_path
    else
      @user.save!
      @admin = Admin.new
      @admin.save!
      @district = District.create_district(@register[:district_name], @register[:address1], @register[:address2], @register[:city], @register[:state], @register[:zipcode])
      @user.role_id = @admin.id
      @user.district_id = @district.id
      @user.save!
      flash[:message] = 'Successfully registered your account.'
      redirect_to users_login_path
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password_digest, :role, :role_id, :district_id)
  end
end
