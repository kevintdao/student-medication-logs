class MedicationsController < ApplicationController
  before_action :set_medication, only: [:show, :edit, :update, :destroy]

  # GET /medications
  # GET /medications.json
  def index
    @pages = session[:page_count]
    @selection = session[:search_term]
    if @pages.nil?
      if @selection.nil? or @selection.blank?
        @medications = Medication.reorder("brand_name ASC").page(params[:page]).per_page(50)
      else
        @medications = Medication.where("lower(brand_name) LIKE ? OR lower(active_ing) LIKE ? OR lower(method) LIKE ?", session[:search_term].downcase, session[:search_term].downcase, session[:search_term].downcase).reorder("brand_name ASC").page(params[:page]).per_page(50)
      end
    else
      if @selection.nil? or @selection.blank?
        @medications = Medication.reorder("brand_name ASC").page(params[:page]).per_page(@pages)
      else
        @medications = Medication.where("lower(brand_name) LIKE ? OR lower(active_ing) LIKE ? OR lower(method) LIKE ?", session[:search_term].downcase, session[:search_term].downcase, session[:search_term].downcase).reorder("brand_name ASC").page(params[:page]).per_page(@pages)
      end
    end
  end
  
  def set_page_count
    unless params[:page_count].nil?
      @pages = params[:page_count][:page_count]
      session[:page_count] = @pages.to_i
    end
    redirect_to medications_path
  end

  def search_meds
    unless params[:search_term].nil?
      session[:search_term] = params[:search_term][:search_term]
    end
    redirect_to medications_path
  end

  # GET /medications/1
  # GET /medications/1.json
  def show
  end

  # GET /medications/new
  def new
    @medication = Medication.new
  end

  # GET /medications/1/edit
  def edit
  end

  # POST /medications
  # POST /medications.json
  def create
    @medication = Medication.new(medication_params)

    respond_to do |format|
      if @medication.save
        format.html { redirect_to @medication, notice: 'Medication was successfully created.' }
        format.json { render :show, status: :created, location: @medication }
      else
        format.html { render :new }
        format.json { render json: @medication.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /medications/1
  # PATCH/PUT /medications/1.json
  def update
    respond_to do |format|
      if @medication.update(medication_params)
        format.html { redirect_to @medication, notice: 'Medication was successfully updated.' }
        format.json { render :show, status: :ok, location: @medication }
      else
        format.html { render :edit }
        format.json { render json: @medication.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /medications/1
  # DELETE /medications/1.json
  def destroy
    @medication.destroy
    respond_to do |format|
      format.html { redirect_to medications_url, notice: 'Medication was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_medication
    @medication = Medication.find(params[:id])
  end

    # Never trust parameters from the scary internet, only allow the white list through.
  def medication_params
    params.require(:medication).permit(:brand_name, :active_ing, :uses, :method, :reactions, :side_effects, :array)
  end
end
