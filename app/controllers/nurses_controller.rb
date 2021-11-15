class NursesController < ApplicationController
  before_action :set_nurse, only: [:show, :edit, :update, :destroy]

  # GET /nurses
  # GET /nurses.json
  def index
    #TODO -- when login is set up, show only events with matching district ID
    # TODO -- switch table to display student names and medication names
    @pages = session[:page_count]
    @selection = session[:search_term]
    if @pages.nil?
      if @selection.nil? or @selection.blank?
        @events = Event.reorder("time ASC").page(params[:page]).per_page(50)
      else
        @events = Event.where("lower(student_id) LIKE ? OR lower(med_id) LIKE ? OR lower(notes) LIKE ?", session[:search_term].downcase, session[:search_term].downcase, session[:search_term].downcase).reorder("time ASC").page(params[:page]).per_page(50)
      end
    else
      if @selection.nil? or @selection.blank?
        @events = Event.reorder("time ASC").page(params[:page]).per_page(@pages)
      else
        @events = Event.where("lower(student_id) LIKE ? OR lower(med_id) LIKE ? OR lower(notes) LIKE ?", session[:search_term].downcase, session[:search_term].downcase, session[:search_term].downcase).reorder("time ASC").page(params[:page]).per_page(@pages)
      end
    end
  end

  def set_page_count
    @pages = params[:page_count][:page_count]
    session[:page_count] = @pages.to_i
    redirect_to nurses_path
  end

  def search_events
    session[:search_term] = params[:search_term][:search_term]
    redirect_to nurses_path
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
end
