class Organizations::OrganizationReportsController < ApplicationController
  include OrganizationLoader
  before_action :set_organization

  layout "edit_organization"

  def index
    @orders = @organization.orders
  end

end
