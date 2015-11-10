class Api::PackagesController < APIController
  # respond_to :json
  #
  # include SetsEvent
  # include LazyCrud
  #
  # set_resource_parent Event
  def index
    @packages = resource_proxy
    render json: @packages, each_serializer: PackageSerializer
  end

  def show
    @package = resource_proxy.find(params[:id])
    render json: @package
  end

  private

  def resource_proxy
    # current_user.hosted_and_collaborated_events
    # TODO: figure out how to scope to hosted_events as well as registered
    Event.find(params[:event_id]).packages
  end

end
