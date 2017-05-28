# TODO: remove
module SetsOrganization
  extend ActiveSupport::Concern

  include OrganizationLoader

  included do
    before_action :set_organization
    helper_method :current_organization
  end
end
