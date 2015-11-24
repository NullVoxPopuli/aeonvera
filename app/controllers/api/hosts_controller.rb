class Api::HostsController < APIController

  def index
    render json: [host_from_subdomain], each_serializer: each_serializer
  end

  def show
    render json: host_from_subdomain, serializer: each_serializer
  end

  private

  def host_from_subdomain
    @host ||= HostOperations::Read.new(current_user, host_params).run
  end

  def host_params
    params.permit(:subdomain)
  end

  def each_serializer
    klass = host_from_subdomain.class

    if klass == Event
      EventSerializer
    else
      CommunitySerializer
    end
  end

end
