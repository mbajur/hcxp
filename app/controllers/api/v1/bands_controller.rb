class Api::V1::BandsController < Api::V1Controller
  before_action :authenticate_user!
  skip_before_filter :verify_authenticity_token
  before_action :set_band, only: [:show]

  respond_to :json

  def index
    @bands = Band.where(id: params[:id_in])
  end

  def create
    @band = Band.new(band_params)

    if @band.save
      render json: {
        success: true,
        band: {
          id: @band.id
        },
        meta: {
          resource: 'band'
        }
      }
    else
      render json: {
        errors:        @band.errors,
        full_messages: @band.errors.full_messages,
        meta: {
          resource: 'errors'
        }
      }, status: :unprocessable_entity
    end
  end

  private

    def band_params
      params.require(:band).permit(:name, :location)
    end

    def set_band
      @band = Band.find(params[:id])
    end

end