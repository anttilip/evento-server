class EventsController < ApplicationController
  before_action :set_event, only: [:show, :update, :destroy, :attendees]
  skip_before_action :authenticate_request, only: [:index, :show, :attendees]

  # GET /events
  def index
    @events = Event.includes(:user, :category).all

    render json: @events
  end

  # GET /events/1
  def show
    render json: @event
  end

  # GET /events/1/attendees
  def attendees
    render json: @event.attendees
  end

  # POST /events
  def create
    # Add @current_user.id to create_params. Only user who sent the request 
    # should be the creator
    @event = Event.new(event_params.merge(creator_id: @current_user.id))

    if @event.save
      # add the creator to the attendees
      @event.attendees << @current_user
      @event.save

      render json: @event, status: :created, location: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /events/1
  def update
    if @current_user.id != @event.creator_id
      render json: { error: 'Not Authorized' }, status: 401
    elsif @event.update(event_params)
      render json: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  # DELETE /events/1
  def destroy
    if @current_user.id == @event.creator_id
      @event.destroy
      render status: 200
    else
      render json: { error: 'Not Authorized' }, status: 401
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def event_params
    params.require(:event).permit(:title, :description, :category_id, :location, :time)
  end
end
