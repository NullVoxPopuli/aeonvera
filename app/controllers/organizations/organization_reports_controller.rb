class Organizations::OrganizationReportsController < ApplicationController
  include OrganizationLoader
  before_action :set_organization

  layout "edit_organization"

  def index
    params[:q].try(:delete, :paid_true) if params[:q].try(:[], :paid_true) == '0'
    @q = @organization.orders.ransack(params[:q])
    @orders = @q.result(distinct: true).includes(:user)

    respond_to do |format|
      format.html{}
      format.csv{
        send_data @orders.to_csv
      }
    end
  end

end
