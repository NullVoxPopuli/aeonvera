# frozen_string_literal: true

# TODO: remove
module OrganizationLoader
  def set_organization(id: nil)
    id = (id || params[:organization_id] || params[:id])
    begin
      @organization = current_user.organizations.find(id)
    rescue
      begin
        @organization = current_user.collaborated_organizations.find(id)
      rescue ActiveRecord::RecordNotFound => e
        # user has nothing to do with the requested event
        redirect_to action: 'index'
      end
    end

    unless @organization
      flash[:alert] = 'Organization Not Found'
      redirect_to root_path
    end
  end

  def current_organization
    @organization
  end
end
