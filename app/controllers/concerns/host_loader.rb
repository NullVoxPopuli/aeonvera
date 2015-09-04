module HostLoader

  include OrganizationLoader
  include EventLoader

  private

  def sets_host
    path = request.path
    host_type = params[:host_type]

    if path.include?("organizations") || host_type == Organization.name
      set_organization
      @host = current_organization
    else
      params[:event_id] = params[:host_id] if (!params[:event_id] && params[:host_id])
      set_event
      @host = current_event
    end
  end

  def current_host
    @host
  end

end
