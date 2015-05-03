class Organizations::MembershipOptions::MembersController < ApplicationController
  include OrganizationLoader
  include MembershipOptionLoader

  before_action :set_organization
  before_action :set_membership_option

  layout "edit_organization"


  def index
    @members = @membership_option.members.all
  end

end
