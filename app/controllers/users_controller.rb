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
    if !(@current_user.present? && @current_user.role == 'Admin')
      flash[:error] = 'Please login as an Admin to continue.'
      redirect_to login_path
    end
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
      redirect_to login_path
    end
  end

  def create_and_email
    # @user = @current_user
    @new_user = params[:new_user]
    pass = SecureRandom.hex # generate random hex value as password
    user = User.new(
      first_name: @new_user[:first_name],
      last_name: @new_user[:last_name],
      email: @new_user[:email],
      password: pass,
      password_confirmation: pass
    )
    user.role = @new_user[:user_type]
    if !user.valid?
      error_message = user.errors.full_messages[0]
      flash[:error] = error_message
      redirect_to users_new_path
    else
      case user.role
      when 'Admin'
        role = Admin.new
      when 'Student'
        role = Student.new
      when 'Nurse'
        role = Nurse.new
      when 'Parent'
        role = Parent.new
      end
      role.save!
      user.role_id = role.id
      # user.district_id = @user.district_id
      user.save!
      user.send_password_set
      redirect_to home_index_path
    end
  end

  def set_password
    @pass = params[:new_pass]
    @user = User.find_by_password_set_token!(params[:format])
    if @user.password_set_sent_at < 2.day.ago
      flash[:error] = 'Password set has expired'
      redirect_to new_password_sets_path
    else
      @user.password = @pass[:password]
      @user.password_confirmation = @pass[:password_confirmation]
      if !@user.valid?
        error_message = @user.errors.full_messages[0]
        flash[:error] = error_message
        redirect_to edit_password_set_url(params[:format])
      else
        @user.save!
        flash[:notice] = 'Password has been set!'
        redirect_to users_login_path
      end
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
