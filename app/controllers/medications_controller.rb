class MedicationsController < ApplicationController
  before_action :set_medication, only: [:show]

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
