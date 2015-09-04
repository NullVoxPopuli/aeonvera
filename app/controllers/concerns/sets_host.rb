module SetsHost
  extend ActiveSupport::Concern

  include HostLoader

  included do
    before_action :sets_host
    helper_method :current_host
  end



end
