class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    # redirect to login if not logged in
    if @current_user.blank?
      redirect_to login_path and return
    end

    district_id = @current_user.district_id
    role = @current_user.role

    if params[:search].present?
      type = params[:search][:type]
      term = params[:search][:term]
      @users = User.search_users(type, term, district_id, role)
      if @users.blank?
        flash[:error] = 'No users found!'
        redirect_to users_path
      end
    else
      @users = User.where(district_id: district_id) if role == 'Admin'
      @users = User.where(district_id: district_id, role: %w[Student Parent]) if role == 'Nurse'
    end
  end

  def dashboard
    unless @current_user.nil?
      role = @current_user.role
      case role
      when 'Nurse'
        redirect_to nurses_path
      when 'Admin'
        redirect_to admins_path
      when 'Parent'
        redirect_to parents_path
      when 'Student'
        redirect_to students_path
      else
        flash[:warning] = "You do not have a dashboard in this system. Please contact your district admin."
        redirect_to home_index_path
      end
    else
      flash[:error] = "You must be logged in to access this page"
      redirect_to home_index_path
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    redirect_to login_path and return if @current_user.blank?

    role = @current_user.role
    district_id = @current_user.district_id
    user_id = params[:id]

    user = User.find_by(district_id: district_id, id: user_id)
    case role
    when 'Admin'
      if user.blank?
        flash[:error] = "You don't have access to this user"
        redirect_to users_path
      end
    when 'Nurse'
      if user.blank? || %w[Parent Admin Nurse].include?(user.role)
        flash[:error] = "You don't have access to this user"
        redirect_to users_path
      end
    when 'Parent'
      flash[:error] = "You don't have access to this"
      redirect_to parents_path
    when 'Student'
      flash[:error] = "You don't have access to this"
      redirect_to students_path
    end

    @events = Event.where(student_id: params[:id])
  end

  # GET /users/new
  def new
    if !(@current_user.present? && @current_user.role == 'Admin')
      flash[:error] = 'Please login as an Admin to continue.'
      redirect_to login_path
    end
  end

  # GET /users/1/edit
  def edit
    if @current_user.nil? || @user != @current_user
      flash[:error] = 'Must be logged in with correct account.'
      redirect_to login_path
    elsif @current_user.role == 'Admin'
      @district = District.find(@current_user.district_id)
    end
  end

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

  def update
    if !@current_user.nil? && @user.id == @current_user.id
      edit_user = params[:edit_user]
      @district = District.find(@user.district_id)
      @user.update(first_name: edit_user[:first_name],
                   last_name: edit_user[:last_name],
                   email: edit_user[:email],
                   phone: edit_user[:phone],
                   email_notification: edit_user[:email_notification],
                   text_notification: edit_user[:text_notification])
      if !@user.valid?
        error_message = @user.errors.full_messages[0]
        flash[:error] = error_message
        redirect_to edit_user_path(@user.id)
      else
        @user.update!(first_name: edit_user[:first_name],
                      last_name: edit_user[:last_name],
                      email: edit_user[:email],
                      phone: edit_user[:phone],
                      email_notification: edit_user[:email_notification],
                      text_notification: edit_user[:text_notification])
        if @user.role == 'Admin'
          District.update_district(@district, edit_user[:district_name], edit_user[:address1],
                                   edit_user[:address2], edit_user[:city], edit_user[:state], edit_user[:zipcode])
        end
        session[:session_token] = @user.session_token
        flash[:notice] = 'Changes saved to your account.'
        redirect_to edit_user_path(@user.id)
      end
    else
      flash[:error] = 'Please login to continue.'
      redirect_to login_path
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
    @user = @current_user
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
      user.district_id = @user.district_id
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
      redirect_to home_index_path
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
        redirect_to login_path
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
