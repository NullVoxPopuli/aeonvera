class Organizations::PaymentProcessorsController < ApplicationController
  include OrganizationLoader

  before_action :set_organization

  layout "edit_organization"

  def index
    @payable = @organization
    render file: '/shared/payment_processors/index'
  end

  def create

  end

  def destroy

  end
end