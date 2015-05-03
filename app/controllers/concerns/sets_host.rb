module SetsHost
  extend ActiveSupport::Concern

  include OrganizationLoader
  include EventLoader

  included do
    before_action :sets_host
    helper_method :current_host
  end

  private

  def sets_host
    path = request.path
    host_type = params[:host_type]
    
    if path.include?("organizations") || host_type == Organization.name
      set_organization
      @host = current_organization
    else
      set_event
      @host = current_event
    end
  end

  def current_host
    @host
  end

end
