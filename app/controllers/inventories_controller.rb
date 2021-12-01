class InventoriesController < ApplicationController
  before_action :set_inventory, only: [:show, :edit, :update, :destroy]
  before_action :is_nurse, only: [:index, :show, :edit, :update, :destroy, :new, :new_item]
  # GET /inventories
  # GET /inventories.json
  def index
    @pages = session[:page_count]
    @selection = session[:search_term]
    if @pages.nil?
      if @selection.nil? or @selection.blank?
        @inventory = Inventory.where(districtID: @current_user.district_id).reorder("medName ASC").page(params[:page]).per_page(50)
      else
        @inventory = Inventory.where(districtID: @current_user.district_id).where("lower(medName) LIKE ? OR lower(notes) LIKE ?", session[:search_term].downcase, session[:search_term].downcase).reorder("medName ASC").page(params[:page]).per_page(50)
      end
    else
      if @selection.nil? or @selection.blank?
        @inventory = Inventory.where(districtID: @current_user.district_id).reorder("medName ASC").page(params[:page]).per_page(@pages)
      else
        @inventory = Inventory.where(districtID: @current_user.district_id).where("lower(medName) LIKE ? OR lower(notes) LIKE ?", session[:search_term].downcase, session[:search_term].downcase).reorder("medName ASC").page(params[:page]).per_page(@pages)
      end
    end
  end

  def set_page_count
    unless params[:page_count].nil?
      @pages = params[:page_count][:page_count]
      session[:page_count] = @pages.to_i
    end
    redirect_to inventories_path
  end

  def search_inv
    unless params[:search_term].nil?
      session[:search_term] = params[:search_term][:search_term]
    end
    redirect_to inventories_path
  end

  # GET /inventories/1
  # GET /inventories/1.json
  def show
  end

  # GET /inventories/new
  def new
  end

  #POST /inventories/new_item
  def new_item
    @item = params[:item]
    @medName = @item[:medName]
    @studentName = @item[:studentName]
    @amount = @item[:amount]
    @notes = @item[:notes]

    # Perform checks for required fields
    if @medName.blank? or @amount.blank?
      flash[:warning] = "You must complete all required fields"
      redirect_to inventories_new_path
    else
      # All required fields are filled, check for proper formatting of amount
      begin
        @amount = @amount.to_i
        if @studentName == "No Student"
          @studentName = nil
        end
        unless @studentName.blank?
          @studentName = @studentName.split
          @fname = @studentName[0]
          @lname = @studentName[1]
          Inventory.create!(medName: @medName, studentID: User.where(first_name: @fname, last_name: @lname).first.id, notes: @notes, amount: @amount, districtID: @current_user.district_id)
        else
          Inventory.create!(medName: @medName, studentID: nil, notes: @notes, amount: @amount, districtID: @current_user.district_id)
        end
        flash[:notice] = "Inventory item created successfully"
        redirect_to inventories_path
      rescue
        flash[:warning] = "You must enter a valid whole number in the amount field and student name must be of the format FirstName LastName"
        redirect_to inventories_new_path
      end
    end
  end

  # GET /inventories/1/edit
  def edit
  end

  # POST /inventories
  # POST /inventories.json
  def create
    @inventory = Inventory.new(inventory_params)

    respond_to do |format|
      if @inventory.save
        format.html { redirect_to @inventory, notice: 'Inventory was successfully created.' }
        format.json { render :show, status: :created, location: @inventory }
      else
        format.html { render :new }
        format.json { render json: @inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inventories/1
  # PATCH/PUT /inventories/1.json
  def update
    respond_to do |format|
      if @inventory.update(inventory_params)
        format.html { redirect_to @inventory, notice: 'Inventory was successfully updated.' }
        format.json { render :show, status: :ok, location: @inventory }
      else
        format.html { render :edit }
        format.json { render json: @inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inventories/1
  # DELETE /inventories/1.json
  def destroy
    @inventory.destroy
    respond_to do |format|
      format.html { redirect_to inventories_url, notice: 'Inventory was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inventory
      @inventory = Inventory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def inventory_params
      params.require(:inventory).permit(:med_id, :amount)
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
