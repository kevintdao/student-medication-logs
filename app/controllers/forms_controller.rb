class FormsController < ApplicationController
  before_action :set_form, only: [:show, :destroy]
  before_action :is_nurse, only: [:new, :new_form, :change_body, :index]
  after_action :clear_search, only: [:new, :new_form, :change_body]
  before_action :is_parent, only: [:parent_view]

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

  # GET /forms/parent_view
  def parent_view
    #TODO: Can only be tested after parent/student association
    @pages = session[:page_count]
    @selection = session[:search_term]
    @students = User.where(role: "Student", role_id: Parent.where(id: @current_user.role_id).first.student_ids).all
    unless @students.nil?
      @ids = @students.map{|s| s.id}
      if @pages.nil?
        if @selection.nil? or @selection.blank?
          @forms = Form.where(districtID: @current_user.district_id, studentID: @ids).page(params[:page]).per_page(50)
        else
          @forms = Form.where(districtID: @current_user.district_id, studentID: @ids).where('body LIKE ?', @selection).all.page(params[:page]).per_page(50)
        end
      else
        if @selection.nil? or @selection.blank?
          @forms = Form.where(districtID: @current_user.district_id, studentID: @ids).page(params[:page]).per_page(@pages)
        else
          @forms = Form.where(districtID: @current_user.district_id, studentID: @ids).where('body LIKE ?', @selection).all.page(params[:page]).per_page(@pages)
        end
      end
    else
      flash[:warning] = "You have no students. Please contact the district admin."
    end
    render 'forms/index'
  end


  #GET /forms/approve_form
  def approve_form
    id = params[:id]
    puts id
    form = Form.where(id: id).first
    if form.nil?
      flash[:error] = "There was a problem approving this form. Please contact the district admin."
      redirect_to :back
    else
    Form.where(id: id).first.update(parent_approved: true)
    flash[:notice] = "Form has been successfully approved"
    redirect_to forms_parent_view_path
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

  def is_parent
    if @current_user.nil?
      # There is no logged in user
      flash[:warning] = "You must be logged in as a parent to access this page."
      redirect_to home_index_path
    else
      # The user is logged in
      unless @current_user.role == "Parent"
        # The user is not a nurse
        flash[:warning] = "You must be a parent to access this page."
        redirect_to home_index_path
      end
    end
  end
end
