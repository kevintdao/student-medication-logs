class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    #TODO -- when login is set up, show only events with matching district ID
    # TODO -- switch table to display student names and medication names
    @pages = session[:page_count]
    @selection = session[:search_term]
    if @pages.nil?
      if @selection.nil? or @selection.blank?
        @events = Event.where(complete: false).reorder("time ASC").page(params[:page]).per_page(50)
      else
        @events = Event.where(complete: false).where("lower(student_id) LIKE ? OR lower(med_id) LIKE ? OR lower(notes) LIKE ?", session[:search_term].downcase, session[:search_term].downcase, session[:search_term].downcase).reorder("time ASC").page(params[:page]).per_page(50)
      end
    else
      if @selection.nil? or @selection.blank?
        @events = Event.where(complete: false).reorder("time ASC").page(params[:page]).per_page(@pages)
      else
        @events = Event.where(complete: false).where("lower(student_id) LIKE ? OR lower(med_id) LIKE ? OR lower(notes) LIKE ?", session[:search_term].downcase, session[:search_term].downcase, session[:search_term].downcase).reorder("time ASC").page(params[:page]).per_page(@pages)
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
        @events = Event.where(complete: true).where("lower(student_id) LIKE ? OR lower(med_id) LIKE ? OR lower(notes) LIKE ?", session[:search_term].downcase, session[:search_term].downcase, session[:search_term].downcase).reorder("time ASC").page(params[:page]).per_page(50)
      end
    else
      if @selection.nil? or @selection.blank?
        @events = Event.where(complete: true).reorder("time ASC").page(params[:page]).per_page(@pages)
      else
        @events = Event.where(complete: true).where("lower(student_id) LIKE ? OR lower(med_id) LIKE ? OR lower(notes) LIKE ?", session[:search_term].downcase, session[:search_term].downcase, session[:search_term].downcase).reorder("time ASC").page(params[:page]).per_page(@pages)
      end
    end
  end

  def set_page_count
    @pages = params[:page_count][:page_count]
    session[:page_count] = @pages.to_i
    redirect_to events_path
  end

  def search_events
    session[:search_term] = params[:search_term][:search_term]
    redirect_to events_path
  end

  def set_past_page_count
    @pages = params[:page_count][:page_count]
    session[:page_count] = @pages.to_i
    redirect_to events_past_events_path
  end

  def search_past_events
    session[:search_term] = params[:search_term][:search_term]
    redirect_to events_past_events_path
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
end
