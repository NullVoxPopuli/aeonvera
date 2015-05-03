module OrganizationLoader
  def set_organization(id: nil)
    id = (id or params[:organization_id] or params[:id])
    begin
      @organization = current_user.organizations.find(id)
    rescue ActiveRecord::RecordNotFound => e
      begin
        @organization = current_user.collaborated_organizations.find(id)
      rescue ActiveRecord::RecordNotFound => e
        begin
          if Subdomain.matches?(request)
            @organization = Organization.find_by_domain(request.subdomain)
          end
        rescue ActiveRecord::RecordNotFound => e
          # user has nothing to do with the requested event
          redirect_to action: "index"
        end
      end
    end

    unless @organization
      flash[:alert] = "Organization Not Found"
      redirect_to root_path
    end

  end

  def current_organization
    @organization
  end
end
