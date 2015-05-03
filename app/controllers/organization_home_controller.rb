class OrganizationHomeController < ApplicationController
  include CurrentSubdomain
  include CurrentOrganization

  layout 'organization_home'


  skip_before_filter :authenticate_user!

  def index
    
  end



end
