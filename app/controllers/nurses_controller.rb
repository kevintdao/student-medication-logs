class NursesController < ApplicationController
  before_action :is_nurse, only: [:index, :show, :edit, :update, :destroy]
  before_action :set_nurse, only: [:show, :edit, :update, :destroy]
  after_action :clear_search

  # GET /nurses
  # GET /nurses.json
  def index
    @nurse = @current_user
  end

  # GET /nurses/1
  # GET /nurses/1.json
  def show
  end

  # GET /nurses/new
  def new
    @nurse = Nurse.new
  end

  # GET /nurses/1/edit
  def edit
  end

  def clear_search
    session[:search_term] = nil
  end

  # POST /nurses
  # POST /nurses.json
  def create
    @nurse = Nurse.new(nurse_params)

    respond_to do |format|
      if @nurse.save
        format.html { redirect_to @nurse, notice: 'Nurse was successfully created.' }
        format.json { render :show, status: :created, location: @nurse }
      else
        format.html { render :new }
        format.json { render json: @nurse.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /nurses/1
  # PATCH/PUT /nurses/1.json
  def update
    respond_to do |format|
      if @nurse.update(nurse_params)
        format.html { redirect_to @nurse, notice: 'Nurse was successfully updated.' }
        format.json { render :show, status: :ok, location: @nurse }
      else
        format.html { render :edit }
        format.json { render json: @nurse.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nurses/1
  # DELETE /nurses/1.json
  def destroy
    @nurse.destroy
    respond_to do |format|
      format.html { redirect_to nurses_url, notice: 'Nurse was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_nurse
      @nurse = Nurse.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def nurse_params
      params.fetch(:nurse, {})
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

