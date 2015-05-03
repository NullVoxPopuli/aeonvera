class HostedEvents::HousingController < ApplicationController
  include SetsEvent


  # from an HTML request, we want both providng and requesting
  # though, for CSV, we want either one or the other, not both
  def index
    html = request.format == 'html'

    if html || params[:providing]
      # providing housing
      @providing_housing = @event.attendances.providing_housing
    end
    if html || (not params[:providing])
      # requesting housing
      @needing_housing = @event.attendances.needing_housing
    end

    respond_to do |format|
      format.html{}
      format.csv{
      	@providing_housing = @providing_housing.to_providing_housing_csv if @providing_housing
      	@needing_housing = @needing_housing.to_requesting_housing_csv if @needing_housing

     	filename = (params[:providing] ? "providing" : "requesting") + ".csv"

        send_data (@providing_housing || @needing_housing), filename: filename
      }
    end
  end

end
