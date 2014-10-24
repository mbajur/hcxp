class EventBandsController < ApplicationController
  before_action :set_event
  before_action :set_event_band, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]
  # load_and_authorize_resource

  # GET /bands
  def index
    @event_bands = @event.event_bands.all
  end

  # GET /bands/new
  def new
    @event_band = @event.event_bands.new
  end

  def add
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:event_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_band_params
      params.require(:band).permit(
        :band_id, :event_id
      )
    end
end
