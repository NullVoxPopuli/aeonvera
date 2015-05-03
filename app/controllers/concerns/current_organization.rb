module CurrentOrganization
  extend ActiveSupport::Concern

  included do
    before_filter :current_organization
    helper_method :current_organization
  end


  private

  def current_organization
    @current_organization ||= Organization.find_by_id(params[:organization_id])
    @current_organization ||= Organization.find_by_domain(current_subdomain)

    if !@current_organization
      flash[:notice] = "Organization was not found. Perhaps it was misspelled?"
      redirect_to calendar_home_index_url(subdomain: '')
      return false
    end

    @current_organization
  end
  
end
