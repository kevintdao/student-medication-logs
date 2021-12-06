class FormsController < ApplicationController
  before_action :set_form, only: [:show, :edit, :update, :destroy]
  before_action :is_nurse, only: [:new, :new_form, :change_body]
  after_action :clear_search, only: [:new, :new_form]

  # GET /forms
  # GET /forms.json
  def index
    @pages = session[:page_count]
    @selection = session[:search_term]
    if @pages.nil?
      if @selection.nil? or @selection.blank?
        @forms = Form.where(districtID: @current_user.district_id).page(params[:page]).per_page(50)
      else
        @forms = Form.where(districtID: @current_user.district_id).where('body LIKE ?', @selection).all.page(params[:page]).per_page(50)
      end
    else
      if @selection.nil? or @selection.blank?
        @forms = Form.where(districtID: @current_user.district_id).page(params[:page]).per_page(@pages)
      else
        @forms = Form.where(districtID: @current_user.district_id).where('body LIKE ?', @selection).all.page(params[:page]).per_page(@pages)
      end
    end
  end

  def set_page_count
    unless params[:page_count].nil?
      @pages = params[:page_count][:page_count]
      session[:page_count] = @pages.to_i
    end
    redirect_to forms_path
  end

  def search_forms
    unless params[:search_term].nil?
      @search = params[:search_term][:search_term]
      session[:search_term] = @search
    end
    redirect_to forms_path
  end

  def clear_search
    session[:search_term] = nil
  end


  # POST /form/change_body
  def change_body
    if params[:body].nil?
      flash[:error] = "There was a problem editing this form"
      redirect_to :back
    else
      @newBody = params[:body][:body]
      @id = params[:body][:id]
      @item = Form.where(id: @id).update_all(body: @newBody, parent_approved: false)
      flash[:notice] = "Form has been successfully updated. Guardian will have to approve again."
      redirect_to forms_path
    end
  end

  # GET /forms/1
  # GET /forms/1.json
  def show
  end

  # GET /forms/new
  def new
  end

  # POST /forms/new_form
  def new_form
    @form = params[:form]
    if @form.nil?
      flash[:error] = "There was a problem creating this form"
      redirect_to :back
    else
      @studentName = @form[:studentName]
      @body = @form[:body]
      if @studentName.blank?
        flash[:warning] = "You must select a student for this form"
        redirect_to :back and return
      end
      if @body.blank?
        flash[:warning] = "You cannot submit a blank form"
        redirect_to :back and return
      end
      @studentName = @studentName.split
      @fname = @studentName[0]
      @lname = @studentName[1]
      Form.create!(nurse_approved: true, body: @body, studentID: User.where(first_name: @fname, last_name: @lname).first.id, parent_approved: false, districtID: @current_user.district_id)
      flash[:notice] = "Form has been successfully created pending guardian approval"
      redirect_to nurses_path
    end
  end


  # GET /forms/1/edit
  def edit
  end

  # POST /forms
  # POST /forms.json
  def create
    @form = Form.new(form_params)

    respond_to do |format|
      if @form.save
        format.html { redirect_to @form, notice: 'Form was successfully created.' }
        format.json { render :show, status: :created, location: @form }
      else
        format.html { render :new }
        format.json { render json: @form.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /forms/1
  # PATCH/PUT /forms/1.json
  def update
    respond_to do |format|
      if @form.update(form_params)
        format.html { redirect_to @form, notice: 'Form was successfully updated.' }
        format.json { render :show, status: :ok, location: @form }
      else
        format.html { render :edit }
        format.json { render json: @form.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forms/1
  # DELETE /forms/1.json
  def destroy
    @form.destroy
    respond_to do |format|
      format.html { redirect_to forms_url, notice: 'Form was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_form
      @form = Form.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def form_params
      params.require(:form).permit(:nurse_approved, :parent_approved, :complete_boolean, :body)
    end

    def is_nurse
      if @current_user.nil?
        # There is no logged in user
        flash[:warning] = "You must be logged in as a nurse to access this page."
        redirect_to home_index_path
      else
        # The user is logged in
        unless @current_user.role == 'Nurse'
          # The user is not a nurse
          flash[:warning] = "You must be a registered nurse to access this page."
          redirect_to home_index_path
        end
      end
    end
end
