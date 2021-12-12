class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :is_nurse, only: [:index, :past_events, :complete, :incomplete, :change_notes]
  before_action :is_parent, only: [:parent_past_events, :parent_view]
  before_action :is_student, only: [:student_past_events, :student_view]
  before_action :belongs_to_district, only: [:show]
  # GET /events
  # GET /events.json
  def index
    @pages = session[:page_count]
    @selection = session[:search_term]

    if @pages.nil?
      if @selection.nil? or @selection.blank?
        @events = Event.where(complete: false, district: @current_user.district_id.to_i).reorder("time ASC").page(params[:page]).per_page(50)
      else
        @events = Event.where(complete: false, district: @current_user.district_id.to_i).where("student_id = ? OR med_id = ?", @selection.downcase, @selection.downcase).reorder("time ASC").page(params[:page]).per_page(50)
      end
    else
      if @selection.nil? or @selection.blank?
        @events = Event.where(complete: false, district: @current_user.district_id.to_i).reorder("time ASC").page(params[:page]).per_page(@pages)
      else
        @events = Event.where(complete: false, district: @current_user.district_id.to_i).where("student_id = ? OR med_id = ?", @selection.downcase, @selection.downcase).reorder("time ASC").page(params[:page]).per_page(@pages)
      end
    end
  end

  def parent_view
    @pages = session[:page_count]
    @selection = session[:search_term]

    if @pages.nil?
      if @selection.nil? or @selection.blank?
        @events = Event.where(complete: false, district: @current_user.district_id.to_i).reorder("time ASC").page(params[:page]).per_page(50)
      else
        @events = Event.where(complete: false, district: @current_user.district_id.to_i).where("student_id = ? OR med_id = ?", @selection.downcase, @selection.downcase).reorder("time ASC").page(params[:page]).per_page(50)
      end
    else
      if @selection.nil? or @selection.blank?
        @events = Event.where(complete: false, district: @current_user.district_id.to_i).reorder("time ASC").page(params[:page]).per_page(@pages)
      else
        @events = Event.where(complete: false, district: @current_user.district_id.to_i).where("student_id = ? OR med_id = ?", @selection.downcase, @selection.downcase).reorder("time ASC").page(params[:page]).per_page(@pages)
      end
    end
    render 'events/index'
  end

  def student_view
    @pages = session[:page_count]
    @selection = session[:search_term]

    if @pages.nil?
      if @selection.nil? or @selection.blank?
        @events = Event.where(complete: false, district: @current_user.district_id.to_i).reorder("time ASC").page(params[:page]).per_page(50)
      else
        @events = Event.where(complete: false, district: @current_user.district_id.to_i).where("student_id = ? OR med_id = ?", @selection.downcase, @selection.downcase).reorder("time ASC").page(params[:page]).per_page(50)
      end
    else
      if @selection.nil? or @selection.blank?
        @events = Event.where(complete: false, district: @current_user.district_id.to_i).reorder("time ASC").page(params[:page]).per_page(@pages)
      else
        @events = Event.where(complete: false, district: @current_user.district_id.to_i).where("student_id = ? OR med_id = ?", @selection.downcase, @selection.downcase).reorder("time ASC").page(params[:page]).per_page(@pages)
      end
    end
    render 'events/index'
  end

  def past_events
    @pages = session[:page_count]
    @selection = session[:search_term]
    if @pages.nil?
      if @selection.nil? or @selection.blank?
        @events = Event.where(complete: true).reorder("time ASC").page(params[:page]).per_page(50)
      else
        @events = Event.where(complete: true).where("student_id = ? OR med_id = ?", @selection.downcase, @selection.downcase).reorder("time ASC").page(params[:page]).per_page(50)
      end
    else
      if @selection.nil? or @selection.blank?
        @events = Event.where(complete: true).reorder("time ASC").page(params[:page]).per_page(@pages)
      else
        @events = Event.where(complete: true).where("student_id = ? OR med_id = ?", @selection.downcase, @selection.downcase).reorder("time ASC").page(params[:page]).per_page(@pages)
      end
    end
  end

  # GET /events/parent_past_events
  def parent_past_events
    @pages = session[:page_count]
    @selection = session[:search_term]
    if @pages.nil?
      if @selection.nil? or @selection.blank?
        @events = Event.where(complete: true).reorder("time ASC").page(params[:page]).per_page(50)
      else
        @events = Event.where(complete: true).where("student_id = ? OR med_id = ?", @selection.downcase, @selection.downcase).reorder("time ASC").page(params[:page]).per_page(50)
      end
    else
      if @selection.nil? or @selection.blank?
        @events = Event.where(complete: true).reorder("time ASC").page(params[:page]).per_page(@pages)
      else
        @events = Event.where(complete: true).where("student_id = ? OR med_id = ?", @selection.downcase, @selection.downcase).reorder("time ASC").page(params[:page]).per_page(@pages)
      end
    end
    render 'events/past_events'
  end

  def student_past_events
    @pages = session[:page_count]
    @selection = session[:search_term]
    if @pages.nil?
      if @selection.nil? or @selection.blank?
        @events = Event.where(complete: true).reorder("time ASC").page(params[:page]).per_page(50)
      else
        @events = Event.where(complete: true).where("student_id = ? OR med_id = ?", @selection.downcase, @selection.downcase).reorder("time ASC").page(params[:page]).per_page(50)
      end
    else
      if @selection.nil? or @selection.blank?
        @events = Event.where(complete: true).reorder("time ASC").page(params[:page]).per_page(@pages)
      else
        @events = Event.where(complete: true).where("student_id = ? OR med_id = ?", @selection.downcase, @selection.downcase).reorder("time ASC").page(params[:page]).per_page(@pages)
      end
    end
    render 'events/past_events'
  end

  def set_page_count
    unless params[:page_count].nil?
      @pages = params[:page_count][:page_count]
      session[:page_count] = @pages.to_i
    end
    case @current_user.role
    when 'Parent'
      redirect_to events_parent_view_path
    when 'Student'
      redirect_to events_student_view_path
    when 'Nurse'
      redirect_to events_path
    end
  end

  def search_events
    session[:search_term] = params[:search_term][:search_term] unless params[:search_term].nil?
    case @current_user.role
    when 'Parent'
      redirect_to events_parent_view_path
    when 'Student'
      redirect_to events_student_view_path
    when 'Nurse'
      redirect_to events_path
    end
  end

  def set_past_page_count
    unless params[:page_count].nil?
      @pages = params[:page_count][:page_count]
      session[:page_count] = @pages.to_i
    end
    case @current_user.role
    when 'Parent'
      redirect_to events_parent_past_events_path
    when 'Student'
      redirect_to events_student_past_events_path
    when 'Nurse'
      redirect_to events_past_events_path
    end
  end

  def search_past_events
    session[:search_term] = params[:search_term][:search_term] unless params[:search_term].nil?
    case @current_user.role
    when 'Parent'
      redirect_to events_parent_past_events_path
    when 'Student'
      redirect_to events_student_past_events_path
    when 'Nurse'
      redirect_to events_past_events_path
    end
  end

  def complete
    if params[:id].nil?
      flash[:error] = "There was a problem marking this event as complete"
    else
      @eventID = params[:id]
      student_id = params[:student_id]
      med_id = params[:med_id]
      med_amount = params[:amount]
      district_id = params[:district_id]
      current_inventory = Inventory.where(studentID: student_id, med_id: med_id, districtID: district_id)

      if current_inventory.first.nil?
        current_inventory = Inventory.where(studentID: nil, med_id: med_id, districtID: district_id)
      end
      total = current_inventory.first.amount

      if (total - med_amount.to_i).negative?
        flash[:error] = "Unable to mark event as complete. You want to remove #{med_amount} doses, but you only have #{total} doses left!"
        redirect_to events_path and return
      end

      @event = Event.where(id: @eventID).update_all(complete: true)
      @inventory = current_inventory.update_all(amount: total - med_amount.to_i)
      flash[:notice] = "Event has been marked as complete"
    end
    redirect_to events_past_events_path
  end

  def incomplete
    if params[:id].nil?
      flash[:error] = "There was a problem marking this event as incomplete"
    else
      @eventID = params[:id]
      student_id = params[:student_id]
      med_id = params[:med_id]
      med_amount = params[:amount]
      district_id = params[:district_id]
      current_inventory = Inventory.where(studentID: student_id, med_id: med_id, districtID: district_id)

      if current_inventory.first.nil?
        current_inventory = Inventory.where(studentID: nil, med_id: med_id, districtID: district_id)
      end
      total = current_inventory.first.amount

      @event = Event.where(id: @eventID).update_all(complete: false)
      @inventory = current_inventory.update_all(amount: total + med_amount.to_i)
      flash[:notice] = "Event has been marked as incomplete"
    end
    redirect_to events_path
  end

  def change_notes
    if params[:notes].nil?
      flash[:error] = "There was a problem editing this note"
    else
      @newNotes = params[:notes][:notes]
      @id = params[:notes][:id]
      @complete = params[:notes][:complete]
      @event = Event.where(id: @id).update_all(notes: @newNotes)
      flash[:notice] = "Notes have been updated successfully"
    end
    if @complete == 'true'
      redirect_to events_past_events_path
    else
      redirect_to events_path
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    redirect_to login_path and return if @current_user.blank?

    @event = Event.new
    district_id = @current_user.district_id

    student_id = params[:student_id]
    @medications = Inventory.where(districtID: district_id, studentID: [student_id, nil])
                            .collect { |med| ["#{med.medName} (Amount: #{med.amount})", med.med_id] }
    render :partial => 'medications' and return if request.xhr?

    @students = User.where(district_id: district_id, role: 'Student')
                    .collect { |user| ["#{user.first_name} #{user.last_name}", user.id] }
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    if event_params['med_id'].blank? || event_params['amount'].blank?
      flash[:error] = "Empty medication/amount"
      redirect_to new_event_path and return
    end
    @event = Event.create!(event_params)
    flash[:notice] = 'Event was successfully created.'
    redirect_to events_path
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:time, :student_id, :med_id, :complete, :notes, :district, :amount)
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
          # The user is not a parent
          flash[:warning] = "You must be a parent to access this page."
          redirect_to home_index_path
        end
      end
    end

    def is_student
      if @current_user.nil?
        # There is no logged in user
        flash[:warning] = "You must be logged in as a student to access this page."
        redirect_to home_index_path
      else
        # The user is logged in
        unless @current_user.role == "Student"
          # The user is not a parent
          flash[:warning] = "You must be a student to access this page."
          redirect_to home_index_path
        end
      end
    end

    def belongs_to_district
      if @current_user.nil?
        # There is no logged in user
        flash[:warning] = "You must be logged in as a nurse to access this page."
        redirect_to home_index_path
      else
        # The user is logged in
        unless @current_user.district_id.to_i == @event.district
          # The user is not in the district
          flash[:warning] = "You must belong to the district to access this page"
          redirect_to home_index_path
        end
      end
    end
end
