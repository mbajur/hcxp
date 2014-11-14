class VenuesController < ApplicationController
  before_action :set_venue, only: [:show, :edit, :update, :destroy]

  # GET /venues
  # GET /venues.json
  # def index
  #   @venues = Venue.all
  # end

  # GET /venues/1
  # GET /venues/1.json
  def show
    redirect_to search_index_path(q: @venue.name)
  end

  # GET /events/autocomplete
  # GET /events/autocomplete.json
  def autocomplete
    render json: Venue.search(params[:q]).map(&:name)
  end

  # GET /venues/1/edit
  def edit
  end

  # PATCH/PUT /venues/1
  # PATCH/PUT /venues/1.json
  def update
    respond_to do |format|
      if @venue.update(venue_params)
        format.html { redirect_to @venue, notice: 'Venue was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @venue.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_venue
      @venue = Venue.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def venue_params
      params.require(:venue).permit(:name, :address, :street, :city, :country_name, :country_code)
    end
end
