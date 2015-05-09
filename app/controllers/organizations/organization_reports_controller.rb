class Organizations::OrganizationReportsController < ApplicationController
  include OrganizationLoader
  before_action :set_organization

  layout "edit_organization"

  def index
    @orders = @organization.orders

    respond_to do |format|
      format.html{}
      format.csv{
        send_data @orders.to_csv
      }
    end
  end

end
