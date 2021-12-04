class RequestsController < ApplicationController
  before_action :set_request, only: [:show, :edit, :update, :destroy]

  # GET /requests
  # GET /requests.json
  def index
    @requests = Request.all
  end

  # GET /requests/1
  # GET /requests/1.json
  def show
  end

  # GET /requests/new
  def new
    if @current_user.nil?
      flash[:error] = 'Must be logged in.'
      redirect_to login_path
    end
    @request = Request.new
  end

  # GET /requests/1/edit
  def edit
  end

  # POST /requests
  # POST /requests.json
  def create
    @request = Request.new(request_params)

    respond_to do |format|
      if @request.save
        format.html { redirect_to @request, notice: 'Request was successfully created.' }
        format.json { render :show, status: :created, location: @request }
      else
        format.html { render :new }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_request
    @request = params[:request]
    @new_request = Request.new(
      student_id: @current_user.id,
      requestor_id: @current_user.id,
      daily_doses: @request[:daily_doses],
      start_date: @request[:start_date],
      end_date: @request[:end_date],
      parent_approved: false,
      nurse_approved: false,
      notes: @request[:notes],
      district_id: @current_user.district_id,
      med_name: @request[:med_name]
    )
    @new_request.time1 = @request[:time1]
    @new_request.time2 = @request[:time2] if @new_request.daily_doses == '2'
    @new_request.time3 = @request[:time3] if @new_request.daily_doses == '3'
    @new_request.time4 = @request[:time4] if @new_request.daily_doses == '4'
    @medication = Medication.where(brand_name: @new_request.med_name.upcase).first
    unless @medication.nil?
      @new_request.med_id = @medication.id
    end
    if !@new_request.valid?
      error_message = @new_request.errors.full_messages[0]
      flash[:error] = error_message
      redirect_to new_request_path
    else
      @new_request.save!
      redirect_to students_path
    end
  end

  # PATCH/PUT /requests/1
  # PATCH/PUT /requests/1.json
  def update
    respond_to do |format|
      if @request.update(request_params)
        format.html { redirect_to @request, notice: 'Request was successfully updated.' }
        format.json { render :show, status: :ok, location: @request }
      else
        format.html { render :edit }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /requests/1
  # DELETE /requests/1.json
  def destroy
    @request.destroy
    respond_to do |format|
      format.html { redirect_to requests_url, notice: 'Request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_request
      @request = Request.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def request_params
      params.require(:request).permit(:time1, :time2, :time3, :time4, :daily_doses, :start_date, :end_date, :student_id, :requestor_id, :med_id, :district_id, :notes, :parent_approved, :nurse_approved)
    end
end
