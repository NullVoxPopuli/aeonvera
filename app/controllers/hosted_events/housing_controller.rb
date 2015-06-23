class HostedEvents::HousingController < ApplicationController
  include SetsEvent


  # from an HTML request, we want both providng and requesting
  # though, for CSV, we want either one or the other, not both
  def index
    html = request.format == 'html'

    if html || params[:providing]
      # providing housing
      providing
    end
    if html || (not params[:providing])
      # requesting housing
      requesting
    end

    respond_to do |format|
      format.html{}
      format.csv{
        filename = (params[:providing] ? "providing" : "requesting") + ".csv"

        send_data (@providing_housing || @needing_housing), filename: filename
      }
    end
  end

  private

  def legacy?
    @event.legacy_housing?
  end

  def csv?
    request.format == "csv"
  end

  def providing
    if legacy?
      @providing_housing = @event.attendances.where(providing_housing: true)
      @providing_housing = @providing_housing.to_providing_housing_csv if csv?
    else
      @providing_housing = @event.housing_provisions
      @providing_housing = @providing_housing.to_csv if csv?
    end
  end

  def requesting
    if legacy?
      @needing_housing = @event.attendances.where(needs_housing: true)
      @needing_housing = @needing_housing.to_requesting_housing_csv if csv?
    else
      @needing_housing = @event.housing_requests
      @needing_housing = @needing_housing.to_csv if csv?
    end
  end

end
