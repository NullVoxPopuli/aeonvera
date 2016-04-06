class Api::HostsController < APIController

  # TODO: is this ever used?
  def index
    render json: [host_from_subdomain], each_serializer: each_serializer
  end

  def show
    return render json: {}, status: 404 unless host_from_subdomain

    render json: host_from_subdomain, include: params[:include], serializer: each_serializer
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
      RegisterEventSerializer
    else
      OrganizationSerializer
    end
  end

end
