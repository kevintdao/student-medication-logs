class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :is_nurse, only: [:index, :past_events, :search_events, :search_past_events, :set_page_count, :set_past_page_count, :complete, :incomplete, :change_notes]

  # GET /events
  # GET /events.json
  def index
    # TODO -- switch table to display student names and medication names
    # session["init"] = true
    @pages = session[:page_count]
    @selection = session[:search_term]

    if @pages.nil?
      if @selection.nil? or @selection.blank?
        @events = Event.where(complete: false, district: @current_user.district_id.to_i).reorder("time ASC").page(params[:page]).per_page(50)
      else
        @events = Event.where(complete: false, district: @current_user.district_id.to_i).where("lower(student_id) LIKE ? OR lower(med_id) LIKE ? OR lower(notes) LIKE ?", @selection.downcase, @selection.downcase, @selection.downcase).reorder("time ASC").page(params[:page]).per_page(50)
      end
    else
      if @selection.nil? or @selection.blank?
        @events = Event.where(complete: false, district: @current_user.district_id.to_i).reorder("time ASC").page(params[:page]).per_page(@pages)
      else
        @events = Event.where(complete: false, district: @current_user.district_id.to_i).where("lower(student_id) LIKE ? OR lower(med_id) LIKE ? OR lower(notes) LIKE ?", @selection.downcase, @selection.downcase, @selection.downcase).reorder("time ASC").page(params[:page]).per_page(@pages)
      end
    end
  end

  def past_events
    @pages = session[:page_count]
    @selection = session[:search_term]
    if @pages.nil?
      if @selection.nil? or @selection.blank?
        @events = Event.where(complete: true).reorder("time ASC").page(params[:page]).per_page(50)
      else
        @events = Event.where(complete: true).where("lower(student_id) LIKE ? OR lower(med_id) LIKE ? OR lower(notes) LIKE ?", @selection.downcase, @selection.downcase, @selection.downcase).reorder("time ASC").page(params[:page]).per_page(50)
      end
    else
      if @selection.nil? or @selection.blank?
        @events = Event.where(complete: true).reorder("time ASC").page(params[:page]).per_page(@pages)
      else
        @events = Event.where(complete: true).where("lower(student_id) LIKE ? OR lower(med_id) LIKE ? OR lower(notes) LIKE ?", @selection.downcase, @selection.downcase, @selection.downcase).reorder("time ASC").page(params[:page]).per_page(@pages)
      end
    end
  end

  def set_page_count
    unless params[:page_count].nil?
      @pages = params[:page_count][:page_count]
      session[:page_count] = @pages.to_i
    end
    redirect_to events_path
  end

  def search_events
    unless params[:search_term].nil?
      session[:search_term] = params[:search_term][:search_term]
    end
    redirect_to events_path
  end

  def set_past_page_count
    unless params[:page_count].nil?
      @pages = params[:page_count][:page_count]
      session[:page_count] = @pages.to_i
    end
    redirect_to events_past_events_path
  end

  def search_past_events
    unless params[:search_term].nil?
      session[:search_term] = params[:search_term][:search_term]
    end
    redirect_to events_past_events_path
  end

  def complete
    if params[:id].nil?
      flash[:error] = "There was a problem marking this event as complete"
    else
      @eventID = params[:id]
      @event = Event.where(id: @eventID).update_all(complete: true)
      flash[:notice] = "Event has been marked as complete"
    end
    redirect_to events_past_events_path
  end

  def incomplete
    if params[:id].nil?
      flash[:error] = "There was a problem marking this event as incomplete"
    else
      @eventID = params[:id]
      @event = Event.where(id: @eventID).update_all(complete: false)
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
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:time, :student_id, :med_id, :complete, :notes)
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
