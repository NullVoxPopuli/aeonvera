class Api::HostsController < APIController
  include HostLoader

  def show
    sets_host

    render json: @host
  end

end
